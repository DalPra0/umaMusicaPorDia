import SwiftUI

struct CollageItem: Identifiable, Equatable {
    let id: UUID
    var image: UIImage
    var offset: CGSize
    var lastOffset: CGSize
    var scale: CGFloat
    var lastScale: CGFloat
    var rotation: Angle
    var lastRotation: Angle
    
    init(id: UUID = UUID(), image: UIImage, offset: CGSize = .zero, lastOffset: CGSize = .zero, scale: CGFloat = 1.0, lastScale: CGFloat = 1.0, rotation: Angle = .zero, lastRotation: Angle = .zero) {
        self.id = id
        self.image = image
        self.offset = offset
        self.lastOffset = lastOffset
        self.scale = scale
        self.lastScale = lastScale
        self.rotation = rotation
        self.lastRotation = lastRotation
    }
    
    static func == (lhs: CollageItem, rhs: CollageItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.offset == rhs.offset &&
        lhs.scale == rhs.scale &&
        lhs.rotation == rhs.rotation
    }
}
