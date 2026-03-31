import SwiftUI

struct CollageItemView: View {
    @Binding var item: CollageItem
    let isSelected: Bool
    var onSelect: () -> Void
    var onInteractionEnded: () -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .contentShape(Rectangle())
            
            if isSelected {
                Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(.blue)
                    .frame(width: 200)
            }
        }
        .rotationEffect(item.rotation)
        .scaleEffect(item.scale)
        .offset(item.offset)
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    onSelect()
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
                    }
                )
        )
    }
}
