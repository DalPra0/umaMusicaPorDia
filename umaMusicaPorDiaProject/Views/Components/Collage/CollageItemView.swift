import SwiftUI

struct CollageItemView: View {
    @Binding var item: CollageItem
    let isSelected: Bool
    var onSelect: () -> Void
    var onInteractionEnded: () -> Void
    
    private let imageFrameWidth: CGFloat = 200
    
    private var activeStrokeWidth: CGFloat {
        if item.strokeWidth > 0 {
            return item.strokeWidth
        }
        return item.isBackgroundRemoved ? 2 : 0
    }
    
    private var activeStrokeColor: Color {
        if item.strokeWidth > 0 {
            return Color(hex: item.strokeColorHex)
        }
        return .white
    }
    
    private var strokeOffsets: [CGSize] {
        let width = max(activeStrokeWidth, 1.0)
        let diagonal = width * 0.7
        return [
            CGSize(width: -width, height: 0), CGSize(width: width, height: 0),
            CGSize(width: 0, height: -width), CGSize(width: 0, height: width),
            CGSize(width: -diagonal, height: -diagonal), CGSize(width: diagonal, height: -diagonal),
            CGSize(width: -diagonal, height: diagonal), CGSize(width: diagonal, height: diagonal)
        ]
    }
    
    var body: some View {
        ZStack {
            if activeStrokeWidth > 0 {
                ZStack {
                    ForEach(Array(strokeOffsets.enumerated()), id: \.offset) { _, strokeOffset in
                        Image(uiImage: item.image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(activeStrokeColor)
                            .scaledToFit()
                            .frame(width: imageFrameWidth)
                            .offset(strokeOffset)
                    }
                }
            }

            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(width: imageFrameWidth)
                .contentShape(Rectangle())
            
            if isSelected {
                Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(.blue)
                    .frame(width: imageFrameWidth)
            }
        }
        .rotationEffect(item.rotation)
        .scaleEffect(item.scale)
        .offset(item.offset)
        .shadow(
            color: item.isBasket ? .black.opacity(0.12) : .clear,
            radius: item.isBasket ? 4 : 0,
            x: 0,
            y: item.isBasket ? 2 : 0
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    onSelect()
                    HapticsManager.shared.playSelection()
                }
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    guard isSelected else { return }
                    item.offset = CGSize(
                        width: item.lastOffset.width + value.translation.width,
                        height: item.lastOffset.height + value.translation.height
                    )
                }
                .onEnded { _ in
                    guard isSelected else { return }
                    item.lastOffset = item.offset
                    onInteractionEnded()
                    HapticsManager.shared.playRelease()
                }
        )
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    guard isSelected else { return }
                    item.scale = item.lastScale * value
                }
                .onEnded { _ in
                    guard isSelected else { return }
                    item.lastScale = item.scale
                    onInteractionEnded()
                    HapticsManager.shared.playRelease()
                }
                .simultaneously(with: RotationGesture()
                    .onChanged { value in
                        guard isSelected else { return }
                        item.rotation = item.lastRotation + value
                    }
                    .onEnded { _ in
                        guard isSelected else { return }
                        item.lastRotation = item.rotation
                        onInteractionEnded()
                        HapticsManager.shared.playRelease()
                    }
                )
        )
    }
}
