import UIKit

enum BasketImageRenderer {
    static func tintedImage(assetName: String, tintColor: UIColor) -> UIImage? {
        guard let sourceImage = UIImage(named: assetName) else { return nil }
        let size = sourceImage.size
        guard size.width > 0, size.height > 0 else { return sourceImage }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = sourceImage.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)

            if let cgImage = sourceImage.cgImage {
                context.cgContext.translateBy(x: 0, y: size.height)
                context.cgContext.scaleBy(x: 1, y: -1)
                context.cgContext.clip(to: rect, mask: cgImage)
                context.cgContext.setFillColor(tintColor.cgColor)
                context.cgContext.fill(rect)
            } else {
                context.cgContext.setFillColor(tintColor.cgColor)
                context.cgContext.fill(rect)
                sourceImage.draw(in: rect, blendMode: .destinationIn, alpha: 1)
            }
        }
    }
}
