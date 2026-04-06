import SwiftUI
import UniformTypeIdentifiers

struct ImageCompressor {
    
    enum CompressionType {
        case collage
        case asset
        
        var maxDimension: CGFloat {
            switch self {
            case .collage: return 1080
            case .asset: return 800
            }
        }
        
        var quality: CGFloat {
            return 0.75
        }
    }

    static func compress(image: UIImage, for type: CompressionType) -> Data? {
        let resizedImage = self.resize(image: image, toMaxDimension: type.maxDimension)
        
        // Remove canal alpha desnecessário para imagens opacas (melhora performance)
        let opaqueImage = self.removeAlphaChannel(from: resizedImage)
        
        let result: Data?
        switch type {
        case .collage:
            result = opaqueImage.jpegData(compressionQuality: type.quality)
            
        case .asset:
            result = opaqueImage.pngData()
        }
        
        if let data = result {
            let sizeMB = Double(data.count) / 1024.0 / 1024.0
            print("✅ Compressão OK: \(type) - \(String(format: "%.2f", sizeMB)) MB")
        } else {
            print("❌ ERRO: Compressão falhou para tipo \(type)")
        }
        
        return result
    }
    
    private static func resize(image: UIImage, toMaxDimension maxDimension: CGFloat) -> UIImage {
        let size = image.size
        
        guard size.width > 0 && size.height > 0 else {
            return image
        }
        
        let widthRatio  = maxDimension / size.width
        let heightRatio = maxDimension / size.height
        
        if widthRatio >= 1 && heightRatio >= 1 {
            return image
        }
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        let targetSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    private static func removeAlphaChannel(from image: UIImage) -> UIImage {
        let size = image.size
        let scale = image.scale
        
        // Cria contexto RGB (sem alpha) para remover canal de transparência
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = true // Força formato opaco (sem alpha)
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
