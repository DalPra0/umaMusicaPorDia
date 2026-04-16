import SwiftUI

struct CollageItem: Identifiable, Equatable {
    let id: UUID
    var image: UIImage
    var originalImage: UIImage
    var maskImage: UIImage?
    var isBackgroundRemoved: Bool
    var offset: CGSize
    var lastOffset: CGSize
    var scale: CGFloat
    var lastScale: CGFloat
    var rotation: Angle
    var lastRotation: Angle
    var strokeColorHex: String
    var strokeWidth: CGFloat
    
    init(id: UUID = UUID(), image: UIImage, originalImage: UIImage? = nil, maskImage: UIImage? = nil, isBackgroundRemoved: Bool = false, offset: CGSize = .zero, lastOffset: CGSize = .zero, scale: CGFloat = 1.0, lastScale: CGFloat = 1.0, rotation: Angle = .zero, lastRotation: Angle = .zero, strokeColorHex: String = "FFFFFF", strokeWidth: CGFloat = 0) {
        self.id = id
        self.image = image
        self.originalImage = originalImage ?? image
        self.maskImage = maskImage
        self.isBackgroundRemoved = isBackgroundRemoved
        self.offset = offset
        self.lastOffset = lastOffset
        self.scale = scale
        self.lastScale = lastScale
        self.rotation = rotation
        self.lastRotation = lastRotation
        self.strokeColorHex = strokeColorHex
        self.strokeWidth = strokeWidth
    }
    
    static func == (lhs: CollageItem, rhs: CollageItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.offset == rhs.offset &&
        lhs.scale == rhs.scale &&
        lhs.rotation == rhs.rotation &&
        lhs.isBackgroundRemoved == rhs.isBackgroundRemoved &&
        lhs.strokeColorHex == rhs.strokeColorHex &&
        lhs.strokeWidth == rhs.strokeWidth
    }
}
