import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            ZStack {
                // 1. Fundo Gradiente Neon
                LinearGradient(
                    colors: [Color(hex: "79F17E"), Color(hex: "6266F2")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // 2. Elementos Fixos (Logo e Page Control)
                VStack {
                    Text("loguinho")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "6266F2"))
                        .padding(.top, geo.safeAreaInsets.top > 0 ? 10 : 30)
                    
                    Spacer()
                    
                    // Page Control (Rosa Choque)
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
                    .padding(.bottom, currentPage == 2 ? 100 : 70)
                }
                .frame(width: size.width)
                .zIndex(100)
                
                // 3. Sistema de Cestas e Frases
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
                        isCenterUpright: true,
                        screenSize: size
                    )
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            let threshold: CGFloat = 40
                            if value.translation.width < -threshold && currentPage < 2 {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    currentPage += 1
                                }
                            } else if value.translation.width > threshold && currentPage > 0 {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    currentPage -= 1
                                }
                            }
                        }
                )
                
                // 4. Botão Final
                if currentPage == 2 {
                    VStack {
                        Spacer()
                        Button(action: {
                            withAnimation { hasCompletedOnboarding = true }
                        }) {
                            Text("COMEÇAR")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
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
        positionIndex == 0 ? 1.0 : 0.4
    }
    
    var body: some View {
        ZStack {
            // Título: Posicionado acima do centro
            if positionIndex == 0 {
                Text(title)
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .offset(y: -screenSize.height * 0.28) // Subi um pouco mais o texto
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            // Grupo Cesta + Sticker
            ZStack {
                // CESTA: Agora menor (0.6)
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width * 0.6) 
                    .rotationEffect(.degrees(isCenterUpright ? 0 : 90))
                
                // STICKER: Agora maior (0.95) para dar destaque
                Image(sticker)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width * 0.95)
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
