import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @Binding var hasCompletedOnboarding: Bool
    
    private let steps: [OnboardingStep] = [
        OnboardingStep(
            title: "Uma música por dia",
            subtitle: "Descubra uma nova melodia todos os dias baseada em uma palavra única.",
            color: .purple,
            icon: "music.note"
        ),
        OnboardingStep(
            title: "Crie Memórias",
            subtitle: "Gere colagens visuais incríveis das suas descobertas musicais.",
            color: .blue,
            icon: "square.stack.3d.up.fill"
        ),
        OnboardingStep(
            title: "Compartilhe a Vibe",
            subtitle: "Mostre ao mundo sua jornada musical diária com apenas um toque.",
            color: .pink,
            icon: "shareplay"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ForEach(0..<steps.count, id: \.self) { index in
                onboardingLayer(for: index)
            }
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Text(steps[currentPage].title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .id("title_\(currentPage)")
                    
                    Text(steps[currentPage].subtitle)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .id("subtitle_\(currentPage)")
                }
                .padding(.bottom, 40)
                
                AppButton(
                    title: currentPage == steps.count - 1 ? "COMEÇAR" : "PRÓXIMO",
                    action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            if currentPage < steps.count - 1 {
                                currentPage += 1
                            } else {
                                hasCompletedOnboarding = true
                            }
                        }
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Capsule()
                            .fill(currentPage == index ? Color.white : Color.gray.opacity(0.3))
                            .frame(width: currentPage == index ? 20 : 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    @ViewBuilder
    private func onboardingLayer(for index: Int) -> some View {
        let isPast = index < currentPage
        let isCurrent = index == currentPage
        
        let yOffset: CGFloat = isPast ? 300 : (isCurrent ? 0 : -600)
        let opacity: Double = isPast ? 0.4 : (isCurrent ? 1.0 : 0.0)
        let scale: CGFloat = isPast ? 0.8 : (isCurrent ? 1.0 : 1.2)
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(steps[index].color.gradient)
                    .frame(width: 280, height: 380)
                    .overlay(
                        Image(systemName: steps[index].icon)
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                    )
                    .shadow(color: steps[index].color.opacity(0.3), radius: 20, x: 0, y: 10)
                
                if isPast {
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                }
            }
            .scaleEffect(scale)
            .offset(y: yOffset)
            .opacity(opacity)
            .blur(radius: isPast ? 4 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .zIndex(Double(index))
    }
}
