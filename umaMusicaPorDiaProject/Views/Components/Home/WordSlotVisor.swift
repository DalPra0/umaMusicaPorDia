import SwiftUI

struct WordSlotVisor: View {
    let viewModel: HomeViewModel
    private let itemHeight: CGFloat = 80
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 302, height: 220)
            
            VStack(spacing: 0) {
                ForEach(viewModel.placeholderWords, id: \.self) { word in
                    wordText(word)
                }
                
                wordText(viewModel.dailyWord?.word.uppercased() ?? "...")
            }
            .offset(y: viewModel.wordsOffset)
            .frame(height: 220, alignment: .top)
            .clipped()
        }
        .offset(y: -70)
    }
    
    private func wordText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(Color(hex: "1E1E1E"))
            .tracking(0.4)
            .frame(height: itemHeight)
    }
}
