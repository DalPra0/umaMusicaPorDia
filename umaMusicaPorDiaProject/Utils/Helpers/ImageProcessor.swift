import SwiftUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

enum ImageProcessorError: Error {
    case maskGenerationFailed
    case contextCreationFailed
    case outputCreationFailed
}

struct ImageProcessor {
    static func removeBackground(from image: UIImage) async throws -> (UIImage, UIImage) {
        guard let cgImage = image.cgImage else { return (image, UIImage()) }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        try handler.perform([request])
        
        guard let result = request.results?.first as? VNInstanceMaskObservation else {
            throw ImageProcessorError.maskGenerationFailed
        }
        
        let maskPixelBuffer = try result.generateMask(forInstances: result.allInstances)
        
        let ciImage = CIImage(cgImage: cgImage)
        let maskImage = CIImage(cvPixelBuffer: maskPixelBuffer)
        
        let scaleX = ciImage.extent.width / maskImage.extent.width
        let scaleY = ciImage.extent.height / maskImage.extent.height
        let scaledMask = maskImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    
        let alphaMaskFilter = CIFilter.colorMatrix()
        alphaMaskFilter.inputImage = scaledMask
        alphaMaskFilter.aVector = CIVector(x: 1, y: 0, z: 0, w: 0)
        alphaMaskFilter.rVector = CIVector(x: 0, y: 0, z: 0, w: 1)
        alphaMaskFilter.gVector = CIVector(x: 0, y: 0, z: 0, w: 1)
        alphaMaskFilter.bVector = CIVector(x: 0, y: 0, z: 0, w: 1)
        
        let context = CIContext(options: nil)
        
        guard let alphaMaskCI = alphaMaskFilter.outputImage,
              let maskCGImage = context.createCGImage(alphaMaskCI, from: alphaMaskCI.extent) else {
            throw ImageProcessorError.outputCreationFailed
        }
        
        let resultMask = UIImage(cgImage: maskCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        let background = CIImage.empty().cropped(to: ciImage.extent)
        let maskedCIImage = ciImage.applyingFilter("CIBlendWithMask", parameters: [
            kCIInputMaskImageKey: alphaMaskCI,
            kCIInputBackgroundImageKey: background
        ])
        
        guard let outputCGImage = context.createCGImage(maskedCIImage, from: maskedCIImage.extent) else {
            throw ImageProcessorError.outputCreationFailed
        }
        let resultImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return (resultImage, resultMask)
    }
    
    static func applyMask(to image: UIImage, mask: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage, let cgMask = mask.cgImage else { return nil }
        
        let ciImage = CIImage(cgImage: cgImage)
        let ciMask = CIImage(cgImage: cgMask)
        
        let scaleX = ciImage.extent.width / ciMask.extent.width
        let scaleY = ciImage.extent.height / ciMask.extent.height
        let scaledMask = ciMask.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        let background = CIImage.empty().cropped(to: ciImage.extent)
        let maskedCIImage = ciImage.applyingFilter("CIBlendWithMask", parameters: [
            kCIInputMaskImageKey: scaledMask,
            kCIInputBackgroundImageKey: background
        ])
        
        let context = CIContext(options: nil)
        guard let outputCGImage = context.createCGImage(maskedCIImage, from: maskedCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
