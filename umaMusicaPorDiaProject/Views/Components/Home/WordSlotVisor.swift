import SwiftUI

struct WordSlotVisor: View {
    let viewModel: HomeViewModel
    private let itemHeight: CGFloat = 60 // Altura menor para caberem mais palavras
    
    var body: some View {
        ZStack {
            // Fundo Branco e Borda Rosa Choque do Visor Gacha (Formato Pílula)
            RoundedRectangle(cornerRadius: 45)
                .fill(Color.white)
                .frame(width: 200, height: 240)
                .overlay(
                    RoundedRectangle(cornerRadius: 45)
                        .stroke(Color(hex: "FC02B2"), lineWidth: 10)
                )
            
            // Área de Texto Giratório (Mostra 3 palavras ao mesmo tempo)
            VStack(spacing: 0) {
                // Palavras antes
                ForEach(viewModel.placeholderWords, id: \.self) { word in
                    wordText(word)
                }
                
                // Palavra atual
                wordText(viewModel.dailyWord?.word.uppercased() ?? "SORTEAR")
            }
            .offset(y: viewModel.wordsOffset + 90) // Centraliza a palavra do meio
            .frame(width: 180, height: 220, alignment: .top)
            .clipped()
        }
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
