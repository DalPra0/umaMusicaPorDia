import SwiftUI

struct CollageCanvasView: View {
    let viewModel: CollageViewModel
    
    var body: some View {
        ZStack {
            viewModel.canvasColor
            
            ForEach(viewModel.items) { item in
                Image(uiImage: item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .rotationEffect(item.rotation)
                    .scaleEffect(item.scale)
                    .offset(item.offset)
            }
        }
        .frame(width: 1080/3, height: 1920/3)
    }
}
