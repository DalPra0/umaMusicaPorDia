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
        
        switch type {
        case .collage:
            return resizedImage.jpegData(compressionQuality: type.quality)
            
        case .asset:
            return resizedImage.pngData()
        }
    }
    
    private static func resize(image: UIImage, toMaxDimension maxDimension: CGFloat) -> UIImage {
        let size = image.size
        
        let widthRatio  = maxDimension / size.width
        let heightRatio = maxDimension / size.height
        
        if widthRatio >= 1 && heightRatio >= 1 { return image }
        
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
}
