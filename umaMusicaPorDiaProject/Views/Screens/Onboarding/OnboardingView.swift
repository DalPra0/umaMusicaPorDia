import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            ZStack {
                // 1. Fundo Gradiente Refinado (Verde sutil no topo, Roxo base)
                ZStack {
                    Color(hex: "6266F2") // Cor de fundo base (Roxo)
                    
                    VStack(spacing: 0) {
                        LinearGradient(
                            colors: [Color(hex: "79F17E"), Color(hex: "6266F2").opacity(0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: size.height * 0.25) // Verde ocupa apenas o topo
                        
                        Spacer()
                        
                        // Degradê de transparência na base (Roxo para Transparente)
                        LinearGradient(
                            colors: [Color(hex: "6266F2").opacity(0), Color(hex: "6266F2")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: size.height * 0.15)
                    }
                }
                .ignoresSafeArea()
                
                // ==========================================
                // PARTE 1: CARROSSEL ANIMADO (Páginas 0, 1 e 2)
                // ==========================================
                if currentPage < 3 {
                    VStack {
                        Text("loguinho")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "6266F2"))
                            .padding(.top, geo.safeAreaInsets.top > 0 ? 10 : 30)
                        Spacer()
                    }
                    .zIndex(100)
                    .transition(.opacity)
                    
                    ZStack {
                        BasketItemView(
                            image: "Basket1Green",
                            sticker: "StickerGreen",
                            title: "Crie coleções\nnostálgicas!",
                            pageIndex: 0,
                            currentPage: currentPage,
                            isCenterUpright: false,
                            screenSize: size
                        )
                        
                        BasketItemView(
                            image: "Basket1Yellow",
                            sticker: "StickerYellow",
                            title: "Salve fotos direto da\ninternet!",
                            pageIndex: 1,
                            currentPage: currentPage,
                            isCenterUpright: false,
                            screenSize: size
                        )
                        
                        BasketItemView(
                            image: "Basket1Blue",
                            sticker: "StickerBlue",
                            title: "Compartilhe nas\nredes sociais!",
                            pageIndex: 2,
                            currentPage: currentPage,
                            isCenterUpright: false,
                            screenSize: size
                        )
                    }
                    
                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? .white : .white.opacity(0.5))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(hex: "FF0080"))
                        .clipShape(Capsule())
                        .padding(.bottom, 70)
                    }
                    .zIndex(100)
                }
                
                // ==========================================
                // PARTE 2: TELA DE RESUMO (Página 3)
                // ==========================================
                if currentPage == 3 {
                    SummaryView(hasCompletedOnboarding: $hasCompletedOnboarding, size: size, safeAreaTop: geo.safeAreaInsets.top)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 40
                        if value.translation.width < -threshold && currentPage < 3 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage += 1
                            }
                        } else if value.translation.width > threshold && currentPage > 0 {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                currentPage -= 1
                            }
                        }
                    }
            )
        }
    }
}

struct BasketItemView: View {
    let image: String
    let sticker: String
    let title: String
    let pageIndex: Int
    let currentPage: Int
    let isCenterUpright: Bool
    let screenSize: CGSize
    
    var positionIndex: Int { pageIndex - currentPage }
    
    var basketYOffset: CGFloat {
        if positionIndex == 0 { return 0 }
        if positionIndex < 0 { return -screenSize.height * 0.48 }
        return screenSize.height * 0.48
    }
    
    var basketScale: CGFloat {
        positionIndex == 0 ? 1.0 : 0.45
    }
    
    var body: some View {
        ZStack {
            if positionIndex == 0 {
                Text(title)
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .offset(y: -screenSize.height * 0.28)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            ZStack {
                // CESTA: Aumentada para 0.75
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width * 0.75) 
                    .rotationEffect(.degrees(isCenterUpright ? 0 : 90))
                
                // STICKER: Equilibrado para 0.85
                Image(sticker)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width * 0.85)
                    .opacity(positionIndex == 0 ? 1.0 : 0.0)
                    .scaleEffect(positionIndex == 0 ? 1.0 : 0.5)
            }
            .scaleEffect(basketScale)
            .offset(y: basketYOffset)
            .opacity(positionIndex == 0 ? 1.0 : 0.3)
        }
        .zIndex(positionIndex == 0 ? 2 : 1)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
    }
}

struct SummaryView: View {
    @Binding var hasCompletedOnboarding: Bool
    let size: CGSize
    let safeAreaTop: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Text("loguinho")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(hex: "6266F2"))
                .padding(.top, safeAreaTop > 0 ? 10 : 30)
            
            Spacer()
            
            VStack(spacing: size.height * 0.02) {
                BasketSummaryItem(
                    image: "Basket1Green",
                    sticker: "StickerGreen",
                    basketWidth: size.width * 0.65, // Aumentado no resumo também
                    stickerWidth: size.width * 0.80
                )
                BasketSummaryItem(
                    image: "Basket1Yellow",
                    sticker: "StickerYellow",
                    basketWidth: size.width * 0.65,
                    stickerWidth: size.width * 0.80
                )
                BasketSummaryItem(
                    image: "Basket1Blue",
                    sticker: "StickerBlue",
                    basketWidth: size.width * 0.65,
                    stickerWidth: size.width * 0.80
                )
            }
            
            Spacer()
            
            Button(action: {
                withAnimation { hasCompletedOnboarding = true }
            }) {
                Text("Começar")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "FF0080"))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, size.height * 0.05)
        }
    }
}

struct BasketSummaryItem: View {
    let image: String
    let sticker: String
    let basketWidth: CGFloat
    let stickerWidth: CGFloat
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: basketWidth)
            
            Image(sticker)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: stickerWidth)
        }
    }
}
