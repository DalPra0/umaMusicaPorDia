import SwiftUI
import PhotosUI
import Auth

@Observable
final class CollageViewModel {
    private let collageService: CollageService
    private let authService: AuthService
    
    enum CanvasRatio: String, CaseIterable {
        case square = "1:1"
        case portrait = "4:5"
        case story = "9:16"
        
        var ratio: CGFloat {
            switch self {
            case .square: return 1.0
            case .portrait: return 4.0/5.0
            case .story: return 9.0/16.0
            }
        }
    }
    
    var items: [CollageItem] = []
    var userAssets: [UserAsset] = []
    var canvasColor: Color = .white
    var canvasBackgroundImage: UIImage?
    var canvasRatio: CanvasRatio = .story
    var selectedItemId: UUID? = nil
    var isSaving = false
    var isLoadingAssets = false
    var isProcessing = false
    var showBackgroundRefinement = false
    var errorMessage: String?
    
    private struct EditorState {
        var items: [CollageItem]
        var canvasColor: Color
        var canvasBackgroundImage: UIImage?
        var canvasRatio: CanvasRatio
        var selectedItemId: UUID?
    }

    private var undoStack: [EditorState] = []
    private var redoStack: [EditorState] = []
    
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    
    init(
        collageService: CollageService = CollageService(),
        authService: AuthService = AuthService(),
        backgroundImageName: String? = nil,
        basketConfiguration: BasketConfiguration? = nil
    ) {
        self.collageService = collageService
        self.authService = authService

        if let basketConfiguration {
            let basketImage: UIImage?
            if basketConfiguration.allowsCustomTint, let tintColor = basketConfiguration.tintColor {
                basketImage = BasketImageRenderer.tintedImage(
                    assetName: basketConfiguration.baseAssetName,
                    tintColor: UIColor(tintColor)
                )
            } else {
                basketImage = UIImage(named: basketConfiguration.baseAssetName)
            }

            if let basketImage {
            let basketItem = CollageItem(
                image: basketImage,
                originalImage: basketImage,
                isBasket: true,
                basketBaseAssetName: basketConfiguration.baseAssetName,
                basketThemeFolderName: basketConfiguration.themeFolderName,
                basketSupportsCustomTint: basketConfiguration.allowsCustomTint,
                basketVariantAssetNames: basketConfiguration.variantAssetNames,
                basketTintHex: basketConfiguration.tintHex
            )
            items.append(basketItem)
            }
        } else if let imageName = backgroundImageName, let uiImage = UIImage(named: imageName) {
            let newItem = CollageItem(image: uiImage)
            items.append(newItem)
        }
    }
    
    func addItem(_ image: UIImage) {
        saveState()
        let newItem = CollageItem(image: image)
        items.append(newItem)
        selectedItemId = newItem.id
        Task { @MainActor in
            HapticsManager.shared.playRelease()
        }
    }
    
    func selectItem(_ id: UUID?) {
        selectedItemId = id
    }
    
    func setCanvasRatio(_ ratio: CanvasRatio) {
        saveState()
        canvasRatio = ratio
    }
    
    func setCanvasColor(_ color: Color) {
        saveState()
        canvasColor = color
    }
    
    func setCanvasBackgroundImage(_ image: UIImage?) {
        saveState()
        canvasBackgroundImage = image
    }

    var isSelectedItemBasket: Bool {
        guard let selectedItem = items.first(where: { $0.id == selectedItemId }) else { return false }
        return selectedItem.isBasket
    }

    var selectedBasketSupportsCustomTint: Bool {
        guard let selectedItem = items.first(where: { $0.id == selectedItemId }) else { return false }
        return selectedItem.isBasket && selectedItem.basketSupportsCustomTint
    }

    var selectedBasketVariantOptions: [BasketVariantOption] {
        guard let selectedItem = items.first(where: { $0.id == selectedItemId }),
              selectedItem.isBasket,
              let variants = selectedItem.basketVariantAssetNames else {
            return []
        }

        return variants.map { assetName in
            BasketVariantOption(
                assetName: assetName,
                title: basketVariantTitle(from: assetName),
                swatchHex: BasketVariantPalette.hex(for: assetName)
            )
        }
    }

    var selectedBasketVariantAssetName: String? {
        guard let selectedItem = items.first(where: { $0.id == selectedItemId }),
              selectedItem.isBasket else {
            return nil
        }
        return selectedItem.basketBaseAssetName
    }

    var selectedBasketColor: Color? {
        guard let selectedItem = items.first(where: { $0.id == selectedItemId }),
              selectedItem.isBasket,
              selectedItem.basketSupportsCustomTint,
              let tintHex = selectedItem.basketTintHex else {
            return nil
        }
        return Color(hex: tintHex)
    }

    func updateSelectedBasketColor(to color: Color) {
        guard let id = selectedItemId,
              let index = items.firstIndex(where: { $0.id == id }),
              items[index].isBasket,
              items[index].basketSupportsCustomTint,
              let baseAssetName = items[index].basketBaseAssetName else {
            return
        }

        let tintHex = color.toHex() ?? items[index].basketTintHex ?? BasketConfiguration.defaultTintHex
        guard let tintedImage = BasketImageRenderer.tintedImage(
            assetName: baseAssetName,
            tintColor: UIColor(color)
        ) else {
            errorMessage = "Não foi possível atualizar a cor da cesta."
            return
        }

        items[index].image = tintedImage
        items[index].originalImage = tintedImage
        items[index].basketTintHex = tintHex
    }

    func updateSelectedBasketVariant(to assetName: String) {
        guard let id = selectedItemId,
              let index = items.firstIndex(where: { $0.id == id }),
              items[index].isBasket,
              !items[index].basketSupportsCustomTint,
              let uiImage = UIImage(named: assetName) else {
            return
        }

        items[index].image = uiImage
        items[index].originalImage = uiImage
        items[index].basketBaseAssetName = assetName
        items[index].basketTintHex = nil
    }
    
    @MainActor
    func removeBackgroundOfSelectedItem() async {
        guard let id = selectedItemId,
              let index = items.firstIndex(where: { $0.id == id }) else { return }
        
        let item = items[index]
        
        if item.isBackgroundRemoved {
            showBackgroundRefinement = true
            return
        }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let originalImage = item.originalImage
            let (processedImage, maskImage) = try await ImageProcessor.removeBackground(from: originalImage)

            if let currentIndex = items.firstIndex(where: { $0.id == id }) {
                if let compressedData = ImageCompressor.compress(image: processedImage, for: .asset),
                   let optimizedImage = UIImage(data: compressedData) {

                    saveState()
                    items[currentIndex].image = optimizedImage
                    items[currentIndex].maskImage = maskImage
                    items[currentIndex].isBackgroundRemoved = true
                } else {
                    saveState()
                    items[currentIndex].image = processedImage
                    items[currentIndex].maskImage = maskImage
                    items[currentIndex].isBackgroundRemoved = true
                }
            }

        } catch {
            print("ERROR: \(error)")
            self.errorMessage = "Erro ao remover fundo"
        }
    }
    
    @MainActor
    func applyRefinedMask(image: UIImage, mask: UIImage) {
        guard let id = selectedItemId,
              let index = items.firstIndex(where: { $0.id == id }) else { return }

        if let compressedData = ImageCompressor.compress(image: image, for: .asset),
           let optimizedImage = UIImage(data: compressedData) {

            saveState()
            items[index].image = optimizedImage
            items[index].maskImage = mask
            showBackgroundRefinement = false
            print("SUCCESS: Sticker optimized and saved")
        } else {
            saveState()
            items[index].image = image
            items[index].maskImage = mask
            showBackgroundRefinement = false
        }
    }
    @MainActor
    func fetchUserAssets() async {
        guard let userId = authService.currentUser?.id else { return }
        guard !isLoadingAssets else { return }
        
        isLoadingAssets = true
        defer { isLoadingAssets = false }
        
        do {
            userAssets = try await collageService.fetchUserAssets(userId: userId)
        } catch {
            self.errorMessage = "Erro ao carregar recortes"
        }
    }
    
    func addRemoteAsset(_ imageUrl: String) {
        Task {
            guard let url = URL(string: imageUrl),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let uiImage = UIImage(data: data) else { return }
            
            await MainActor.run {
                addItem(uiImage)
            }
        }
    }
    
    func saveState() {
        if undoStack.count > 20 { undoStack.removeFirst() }
        undoStack.append(currentState)
        redoStack.removeAll()
    }
    
    func undo() {
        guard let lastState = undoStack.popLast() else { return }
        redoStack.append(currentState)
        apply(state: lastState)
    }
    
    func redo() {
        guard let nextState = redoStack.popLast() else { return }
        undoStack.append(currentState)
        apply(state: nextState)
    }
    
    func saveCollage(wordId: UUID, image: UIImage, assets: [CollageAsset]) async {
        guard let userId = authService.currentUser?.id else {
            self.errorMessage = "Usuário não autenticado"
            return
        }
        
        isSaving = true
        defer { isSaving = false }

        guard let compressedData = ImageCompressor.compress(image: image, for: .collage) else {
            self.errorMessage = "Erro ao processar imagem"
            return
        }
        
        do {
            try await collageService.saveCollage(userId: userId, wordId: wordId, imageData: compressedData, assets: assets)
            await NotificationManager.shared.markCollageAsCreatedToday()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    private var currentState: EditorState {
        EditorState(
            items: items,
            canvasColor: canvasColor,
            canvasBackgroundImage: canvasBackgroundImage,
            canvasRatio: canvasRatio,
            selectedItemId: selectedItemId
        )
    }

    private func apply(state: EditorState) {
        items = state.items
        canvasColor = state.canvasColor
        canvasBackgroundImage = state.canvasBackgroundImage
        canvasRatio = state.canvasRatio
        selectedItemId = state.selectedItemId
    }

    private func basketVariantTitle(from assetName: String) -> String {
        let knownColors = ["Blue", "Green", "Pink", "Red", "Yellow", "Purple", "Beige"]
        if let color = knownColors.first(where: { assetName.localizedCaseInsensitiveContains($0) }) {
            return color
        }
        return "Original"
    }
}
