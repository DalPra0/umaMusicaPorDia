import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradiente de fundo
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.6, green: 1.0, blue: 0.6),
                        Color(red: 0.5, green: 0.4, blue: 0.9),
                        Color(red: 0.6, green: 1.0, blue: 0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                TabView(selection: $currentPage) {
                    // Tela 1 - Verde
                    OnboardingPage1()
                        .tag(0)
                    
                    // Tela 2 - Amarelo
                    OnboardingPage2()
                        .tag(1)
                    
                    // Tela 3 - Azul
                    OnboardingPage3(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()
                
                // Logo e controles fixos
                VStack {
                    // Logo no topo
                    Text("loquinho")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.5, green: 0.4, blue: 0.9))
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    // Indicadores de página
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

// TELA 1: Cesta verde NO MEIO
struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 120)
            
            Text("Crie coleções\nnostálgicas!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 40)
            
            // Cesta verde no centro com sticker
            ZStack {
                Image("Basket1Green")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500)
                    .rotationEffect(.degrees(90))
                
                // Sticker verde
                Image("StickerGreen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280)
            }
            
            Spacer()
        }
    }
}

// TELA 2: Cesta amarela LÁ EMBAIXO (quase fora da tela)
struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 120)
            
            Text("Salve fotos direto da\ninternet!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // Cesta amarela lá embaixo com sticker
            ZStack {
                Image("Basket1Yellow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500)
                    .rotationEffect(.degrees(90))
                    .offset(y: 150) // Empurra pra baixo (quase fora da tela)
                
                // Sticker amarelo
                Image("StickerYellow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 340)
                    .offset(y: -40)
            }
        }
    }
}

// TELA 3: Cesta azul embaixo (sem sticker)
struct OnboardingPage3: View {
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 120)
            
            Text("Compartilhe nas\nredes sociais!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // Cesta azul embaixo (sem rotação)
            Image("Basket1Blue")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400)
                .offset(y: 80)
            
            Spacer()
                .frame(height: 40)
            
            // Botão começar
            Button(action: {
                hasCompletedOnboarding = true
            }) {
                Text("COMEÇAR")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 80)
        }
    }
}
