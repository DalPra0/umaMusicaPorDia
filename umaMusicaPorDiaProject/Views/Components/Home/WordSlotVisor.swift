import SwiftUI

struct WordSlotVisor: View {
    let viewModel: HomeViewModel
    private let itemHeight: CGFloat = 60
    private let visorHeight: CGFloat = 220
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 45)
                .fill(Color.white)
                .frame(width: 200, height: 240)
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .stroke(Color(hex: "FC02B2"), lineWidth: 10)
                )
            
            VStack(spacing: 0) {
                ForEach(Array(viewModel.slotWords.enumerated()), id: \.offset) { _, word in
                    wordText(word)
                }
            }
            .offset(y: viewModel.wordsOffset + centerOffset)
            .frame(width: 180, height: visorHeight, alignment: .top)
            .clipped()
        }
    }

    private var centerOffset: CGFloat {
        (visorHeight - itemHeight) / 2
    }
    
    private func wordText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(width: 160, height: itemHeight)
    }
}
