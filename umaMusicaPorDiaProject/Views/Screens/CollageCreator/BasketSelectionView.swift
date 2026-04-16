import SwiftUI

struct BasketSelectionView: View {
    @State private var selectedThemeIndex: Int? = BasketTheme.defaultSelectionIndex
    @State private var navigateToNext = false
    @State private var showThemeSettings = false
    let dailyWord: DailyWord
    
    var body: some View {
        GeometryReader { screenGeometry in
            ZStack(alignment: .bottom) {
                Color(hex: "6759F1")
                    .ignoresSafeArea()
                
                Image("Basket1Purple")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 285, height: 406.97)
                    .position(x: screenGeometry.size.width / 2, y: screenGeometry.size.height + 10)
                    .accessibilityHidden(true)
                
                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 16)
                        .padding(.top, 66)
                    
                    Text("Escolha seu modelo")
                        .font(.system(size: 34, weight: .bold))
                        .tracking(0.4)
                        .foregroundStyle(Color(hex: "81E862"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 38)
                        .padding(.top, 31)
                    
                    GeometryReader { carouselGeo in
                        let itemHeight = min(359.0, carouselGeo.size.height * 0.88)
                        let verticalInset = max((carouselGeo.size.height - itemHeight) / 2, 0)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(Array(BasketTheme.allThemes.enumerated()), id: \.offset) { index, theme in
                                    modelCard(theme)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: itemHeight)
                                        .id(index)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: $selectedThemeIndex)
                        .safeAreaPadding(.vertical, verticalInset)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
                
                LinearGradient(
                    colors: [Color(hex: "81E862").opacity(0), Color(hex: "81E862")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 450)
                .allowsHitTesting(false)
                
                Button {
                    navigateToNext = true
                } label: {
                    Text("Continuar")
                        .font(.system(size: 18, weight: .bold))
                        .tracking(-0.23)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 43, maxHeight: 43)
                        .background(Color(hex: "FC02B2"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                .padding(.horizontal, 20)
                .padding(.bottom, 52)
                .accessibilityHint("Abre a próxima etapa para a palavra \(dailyWord.word)")
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToNext) {
            destinationForTheme(selectedTheme)
        }
        .confirmationDialog("Modelos", isPresented: $showThemeSettings, titleVisibility: .visible) {
            ForEach(Array(BasketTheme.allThemes.enumerated()), id: \.offset) { index, theme in
                Button(theme.name) { selectedThemeIndex = index }
            }
        }
    }
    
    private var selectedTheme: BasketTheme {
        let index = selectedThemeIndex ?? BasketTheme.defaultSelectionIndex
        return BasketTheme.allThemes[index]
    }
    
    private var header: some View {
        HStack {
            Spacer()
            Button(action: { showThemeSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(hex: "81E862"))
                    .frame(width: 58, height: 28, alignment: .trailing)
            }
            .accessibilityLabel("Configurações de modelo")
        }
    }
    
    private func modelCard(_ theme: BasketTheme) -> some View {
        Image(theme.greenPreviewImageName)
            .resizable()
            .scaledToFit()
            .frame(width: 297.07, height: 359)
            .accessibilityLabel("Modelo \(theme.name)")
    }
    
    @ViewBuilder
    private func destinationForTheme(_ theme: BasketTheme) -> some View {
        if theme.variants.count > 1 {
            ColorSelectionView(theme: theme, dailyWord: dailyWord)
        } else {
            CollageCreatorView(backgroundImageName: theme.previewImageName, dailyWord: dailyWord)
        }
    }
}

private extension BasketTheme {
    static var defaultSelectionIndex: Int {
        allThemes.firstIndex(where: { $0.folderName == "Basket1" }) ?? 0
    }
    
    var greenPreviewImageName: String {
        variants.first(where: { $0.localizedCaseInsensitiveContains("green") }) ?? previewImageName
    }
}
