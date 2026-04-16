import SwiftUI
import RevenueCatUI

struct ColorSelectionView: View {
    let theme: BasketTheme
    let dailyWord: DailyWord
    @Environment(\.dismiss) var dismiss
    @Environment(SubscriptionManager.self) var subscriptionManager
    @State private var showPaywall = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "D9D9D9")
                .ignoresSafeArea()
            
            GeometryReader { screenGeometry in
                let screenHeight = screenGeometry.size.height
                let itemHeight = screenHeight * 0.75
                
                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    
                    titleHeader
                        .padding(.horizontal, 44)
                        .padding(.top, 24)
                    
                    // Seletor de Cores com Trava (Snap)
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(Array(theme.variants.enumerated()), id: \.offset) { index, variant in
                                let isLocked = index >= 3 && !subscriptionManager.isPremium

                                if isLocked {
                                    Button(action: { showPaywall = true }) {
                                        colorCard(variant)
                                            .frame(height: itemHeight)
                                            .overlay(
                                                VStack(spacing: 12) {
                                                    Image(systemName: "lock.fill")
                                                        .font(.system(size: 40))
                                                        .foregroundColor(.white)
                                                        .shadow(radius: 4)
                                                    Text("PREMIUM")
                                                        .font(.system(size: 14, weight: .bold))
                                                        .foregroundColor(.white)
                                                        .tracking(2)
                                                }
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .background(Color.black.opacity(0.15))
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    NavigationLink(destination: CollageCreatorView(backgroundImageName: variant, dailyWord: dailyWord)) {
                                        colorCard(variant)
                                            .frame(height: itemHeight)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.vertical, (screenHeight - itemHeight) / 2)
                }
            }
            
            LinearGradient(
                colors: [Color(hex: "D9D9D9").opacity(0), Color(hex: "D9D9D9")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 250)
            .allowsHitTesting(false)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showPaywall, onDismiss: {
            subscriptionManager.checkSubscriptionStatus()
        }) {
            PaywallView(displayCloseButton: true)
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
    
    private var titleHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Escolha a cor para:")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(-0.31)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(theme.name)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(0.4)
        }
    }
    
    private func colorCard(_ variant: String) -> some View {
        VStack(spacing: 30) {
            Image(variant)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 68)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            
            let colorName = extractColorName(from: variant)
            Text(colorName.uppercased())
                .font(.system(size: 22, weight: .black))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(4)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func extractColorName(from variant: String) -> String {
        let colors = ["Blue", "Green", "Pink", "Red", "Yellow", "Beige"]
        for color in colors {
            if variant.contains(color) { return color }
        }
        return "Original"
    }
}
