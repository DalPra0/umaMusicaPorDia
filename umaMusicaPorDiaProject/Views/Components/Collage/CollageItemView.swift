import SwiftUI

struct CollageItemView: View {
    @Binding var item: CollageItem
    var onInteractionEnded: () -> Void
    
    var body: some View {
        Image(uiImage: item.image)
            .resizable()
            .scaledToFit()
            .frame(width: 200)
            .rotationEffect(item.rotation)
            .scaleEffect(item.scale)
            .offset(item.offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        item.offset = CGSize(
                            width: item.lastOffset.width + value.translation.width,
                            height: item.lastOffset.height + value.translation.height
                        )
                    }
                    .onEnded { _ in
                        item.lastOffset = item.offset
                        onInteractionEnded()
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in item.scale = item.lastScale * value }
                    .onEnded { _ in
                        item.lastScale = item.scale
                        onInteractionEnded()
                    }
                    .simultaneously(with: RotationGesture()
                        .onChanged { value in item.rotation = item.lastRotation + value }
                        .onEnded { _ in
                            item.lastRotation = item.rotation
                            onInteractionEnded()
                        }
                    )
            )
    }
}
