import SwiftUI

struct ColorSelectionView: View {
    let theme: BasketTheme
    @Environment(\.dismiss) var dismiss
    
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
                            ForEach(theme.variants, id: \.self) { variant in
                                NavigationLink(destination: CollageCreatorView(backgroundImageName: variant)) {
                                    colorCard(variant)
                                        .frame(height: itemHeight)
                                }
                                .buttonStyle(PlainButtonStyle())
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
