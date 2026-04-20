import SwiftUI

struct BasketSelectionView: View {
    @State private var selectedThemeIndex: Int? = BasketTheme.defaultSelectionIndex
    @State private var selectedColorHex = BasketConfiguration.defaultTintHex
    @State private var selectedVariantByFolder: [String: String] = [:]
    @State private var navigateToNext = false
    @State private var showSettings = false
    @State private var settingsViewModel = HomeViewModel()
    let dailyWord: DailyWord
    @Environment(SubscriptionManager.self) private var subscriptionManager
    
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
                
                VStack(spacing: 12) {
                    colorCustomizationPanel

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
                    .accessibilityHint("Abre a próxima etapa para a palavra \(dailyWord.word)")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToNext) {
            CollageCreatorView(basketConfiguration: selectedBasketConfiguration, dailyWord: dailyWord)
        }
        .sheet(isPresented: $showSettings) {
            SettingsSheet(viewModel: settingsViewModel)
        }
    }
    
    private var selectedTheme: BasketTheme {
        let index = selectedThemeIndex ?? BasketTheme.defaultSelectionIndex
        return BasketTheme.allThemes[index]
    }

    private var selectedBasketConfiguration: BasketConfiguration {
        if selectedTheme.supportsCustomColorSelection && canCustomizeColor {
            return BasketConfiguration(
                themeName: selectedTheme.name,
                themeFolderName: selectedTheme.folderName,
                allowsCustomTint: true,
                variantAssetNames: selectedTheme.variants,
                baseAssetName: selectedTheme.whiteAssetName ?? selectedTheme.previewImageName,
                tintHex: selectedColorHex
            )
        }

        return BasketConfiguration(
            themeName: selectedTheme.name,
            themeFolderName: selectedTheme.folderName,
            allowsCustomTint: false,
            variantAssetNames: selectedTheme.variants,
            baseAssetName: selectedVariantAssetName(for: selectedTheme),
            tintHex: nil
        )
    }

    private var selectedColor: Color {
        Color(hex: selectedColorHex)
    }

    private var canCustomizeColor: Bool {
        BasketColorAccessPolicy.canCustomizeColor(isPremium: subscriptionManager.isPremium)
    }

    private var selectedColorBinding: Binding<Color> {
        Binding(
            get: { selectedColor },
            set: { newValue in
                selectedColorHex = newValue.toHex() ?? selectedColorHex
            }
        )
    }
    
    private var header: some View {
        HStack {
            Spacer()
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(hex: "81E862"))
                    .frame(width: 58, height: 28, alignment: .trailing)
            }
            .accessibilityLabel("Configurações")
        }
    }
    
    private var colorCustomizationPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Cor da cesta")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)

            if selectedTheme.supportsCustomColorSelection && canCustomizeColor {
                HStack(spacing: 8) {
                    ForEach(BasketConfiguration.swatchHexes, id: \.self) { hex in
                        let swatchColor = Color(hex: hex)
                        Button {
                            selectedColorHex = hex
                        } label: {
                            Circle()
                                .fill(swatchColor)
                                .frame(width: 24, height: 24)
                                .overlay {
                                    Circle()
                                        .stroke(
                                            selectedColorHex == hex ? Color.white : Color.white.opacity(0.4),
                                            lineWidth: selectedColorHex == hex ? 2 : 1
                                        )
                                }
                                .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                        }
                    }
                }

                HStack {
                    Text("Mais cores")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.9))

                    Spacer()

                    ColorPicker("", selection: selectedColorBinding, supportsOpacity: false)
                        .labelsHidden()
                }
            } else if selectedTheme.supportsCustomColorSelection {
                Text("Personalização de cor disponível no premium.")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.9))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedTheme.variantOptions) { option in
                            let isSelected = selectedVariantAssetName(for: selectedTheme) == option.assetName
                            Button {
                                selectedVariantByFolder[selectedTheme.folderName] = option.assetName
                            } label: {
                                HStack(spacing: 6) {
                                    if let swatchHex = option.swatchHex {
                                        Circle()
                                            .fill(Color(hex: swatchHex))
                                            .frame(width: 14, height: 14)
                                    }
                                    Text(option.title)
                                        .font(.system(size: 12, weight: .semibold))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(isSelected ? Color.white.opacity(0.25) : Color.white.opacity(0.12))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(isSelected ? 0.95 : 0.35), lineWidth: 1)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .foregroundStyle(.white)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func modelCard(_ theme: BasketTheme) -> some View {
        Group {
            if theme.supportsCustomColorSelection && canCustomizeColor {
                Image(displayedAssetName(for: theme))
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(selectedColor)
            } else {
                Image(displayedAssetName(for: theme))
                    .resizable()
            }
        }
        .scaledToFit()
        .frame(width: 297.07, height: 359)
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
        .accessibilityLabel("Modelo \(theme.name)")
    }

    private func displayedAssetName(for theme: BasketTheme) -> String {
        if theme.supportsCustomColorSelection && canCustomizeColor {
            return theme.whiteAssetName ?? theme.previewImageName
        }
        return selectedVariantAssetName(for: theme)
    }

    private func selectedVariantAssetName(for theme: BasketTheme) -> String {
        selectedVariantByFolder[theme.folderName] ?? theme.previewImageName
    }
}

private extension BasketTheme {
    static var defaultSelectionIndex: Int {
        allThemes.firstIndex(where: { $0.folderName == "Basket1" }) ?? 0
    }
}
