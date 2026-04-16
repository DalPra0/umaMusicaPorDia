import SwiftUI

struct CollageCanvasView: View {
    let viewModel: CollageViewModel
    
    var body: some View {
        ZStack {
            viewModel.canvasColor

            if let backgroundImage = viewModel.canvasBackgroundImage {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 1080 / 3, height: 1920 / 3)
                    .clipped()
            }
            
            ForEach(viewModel.items) { item in
                ZStack {
                    if strokeWidth(for: item) > 0 {
                        ForEach(Array(strokeOffsets(for: strokeWidth(for: item)).enumerated()), id: \.offset) { _, strokeOffset in
                            Image(uiImage: item.image)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(strokeColor(for: item))
                                .scaledToFit()
                                .frame(width: 200)
                                .offset(strokeOffset)
                        }
                    }

                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                .rotationEffect(item.rotation)
                .scaleEffect(item.scale)
                .offset(item.offset)
            }
        }
        .frame(width: 1080/3, height: 1920/3)
    }

    private func strokeWidth(for item: CollageItem) -> CGFloat {
        if item.strokeWidth > 0 {
            return item.strokeWidth
        }
        return item.isBackgroundRemoved ? 2 : 0
    }

    private func strokeColor(for item: CollageItem) -> Color {
        if item.strokeWidth > 0 {
            return Color(hex: item.strokeColorHex)
        }
        return .white
    }

    private func strokeOffsets(for width: CGFloat) -> [CGSize] {
        let w = max(width, 1.0)
        let diagonal = w * 0.7
        return [
            CGSize(width: -w, height: 0), CGSize(width: w, height: 0),
            CGSize(width: 0, height: -w), CGSize(width: 0, height: w),
            CGSize(width: -diagonal, height: -diagonal), CGSize(width: diagonal, height: -diagonal),
            CGSize(width: -diagonal, height: diagonal), CGSize(width: diagonal, height: diagonal)
        ]
    }
}
