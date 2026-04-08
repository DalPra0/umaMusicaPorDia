import SwiftUI

struct BasketSelectionView: View {
    @Environment(\.dismiss) var dismiss
    let dailyWord: String
    
    var body: some View {
        NavigationStack {
            GeometryReader { screenGeometry in
                let screenHeight = screenGeometry.size.height
                // Aumentamos para 75% da tela para ser realmente imersivo
                let itemHeight = screenHeight * 0.75
                
                ZStack(alignment: .bottom) {
                    Color(hex: "D9D9D9")
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        header
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        wordHeader
                            .padding(.horizontal, 44)
                            .padding(.top, 24)
                        
                        // ScrollView com trava (Snap) garantida no centro
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(BasketTheme.allThemes) { theme in
                                    NavigationLink(destination: destinationForTheme(theme)) {
                                        basketCard(theme)
                                            .frame(height: itemHeight)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        // Padding calculado para o primeiro e o último item pararem no centro exato
                        .safeAreaPadding(.vertical, (screenHeight - itemHeight) / 2)
                    }
                    
                    // 2. Gradiente APENAS na parte de baixo
                    LinearGradient(
                        colors: [Color(hex: "D9D9D9").opacity(0), Color(hex: "D9D9D9")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 250)
                    .allowsHitTesting(false)
                }
            }
        }
    }
    
    // MARK: - Components
    
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            Spacer()
        }
    }
    
    private var wordHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("A palavra do dia é:")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(-0.31)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(dailyWord.uppercased())
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(0.4)
        }
    }
    
    private func basketCard(_ theme: BasketTheme) -> some View {
        VStack(spacing: 20) {
            Image(theme.previewImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                // Margem responsiva de 68px como no Figma
                .padding(.horizontal, 68) 
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            
            Text(theme.name)
                .font(.system(size: 22, weight: .black))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(4)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func destinationForTheme(_ theme: BasketTheme) -> some View {
        if theme.variants.count > 1 {
            ColorSelectionView(theme: theme)
        } else {
            CollageCreatorView(backgroundImageName: theme.previewImageName)
        }
    }
}
