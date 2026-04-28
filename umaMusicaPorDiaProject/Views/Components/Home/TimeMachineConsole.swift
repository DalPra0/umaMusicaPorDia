import SwiftUI

struct TimeMachineConsole: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            ZStack(alignment: .top) {
                // 1. Imagem de Fundo da Máquina Gacha (Imersiva)
                Image("gacha")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width * 1.3)
                    .offset(y: -size.height * 0.15) // Sobe a imagem
                
                // 2. Área do Logo (Superior)
                Image("LogoBentoRoxo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 132, height: 68)
                    .offset(y: size.height * 0.12) // Alinhado com a máquina subida
                
                // 3. Visor de Palavras (Centralizado no buraco da máquina)
                WordSlotVisor(viewModel: viewModel)
                    .offset(y: size.height * 0.32) // Ajustado proporcionalmente
            }
            .frame(width: size.width)
        }
    }
}
