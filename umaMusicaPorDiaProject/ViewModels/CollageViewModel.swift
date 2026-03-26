import SwiftUI
import PhotosUI
import Auth

@Observable
final class CollageViewModel {
    // Serviços
    private let collageService: CollageService
    private let authService: AuthService
    
    // Estados da UI
    var items: [CollageItem] = []
    var userAssets: [UserAsset] = []
    var canvasColor: Color = .white
    var isSaving = false
    var isLoadingAssets = false
    var errorMessage: String?
    
    // Undo / Redo Stacks
    private var undoStack: [[CollageItem]] = []
    private var redoStack: [[CollageItem]] = []
    
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    
    init(collageService: CollageService = CollageService(), authService: AuthService = AuthService()) {
        self.collageService = collageService
        self.authService = authService
    }
    
    func addItem(_ image: UIImage) {
        saveState()
        items.append(CollageItem(image: image))
    }
    
    func toggleCanvasColor() {
        saveState()
        canvasColor = (canvasColor == .white) ? Color(hex: "F0F0F0") : .white
    }
    
    @MainActor
    func fetchUserAssets() async {
        guard let userId = authService.currentUser?.id else {
            print("DEBUG: fetchUserAssets cancelado - Usuário não logado no app principal")
            return
        }
        guard !isLoadingAssets else { return }
        
        isLoadingAssets = true
        defer { isLoadingAssets = false }
        
        print("DEBUG: Buscando assets para o usuário: \(userId.uuidString)")
        
        do {
            userAssets = try await collageService.fetchUserAssets(userId: userId)
            print("DEBUG: Busca concluída! Encontrados \(userAssets.count) assets.")
            for asset in userAssets {
                print("DEBUG: Asset ID: \(asset.id) | URL: \(asset.imageUrl)")
            }
        } catch {
            print("DEBUG: ERRO CRÍTICO ao buscar assets: \(error)")
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
    
    // MARK: - Undo / Redo
    
    func saveState() {
        if undoStack.count > 20 { undoStack.removeFirst() }
        undoStack.append(items)
        redoStack.removeAll()
    }
    
    func undo() {
        guard let lastState = undoStack.popLast() else { return }
        redoStack.append(items)
        items = lastState
    }
    
    func redo() {
        guard let nextState = redoStack.popLast() else { return }
        undoStack.append(items)
        items = nextState
    }
    
    // MARK: - Persistence
    
    func saveCollage(wordId: UUID, imageData: Data, assets: [CollageAsset]) async {
        guard let userId = authService.currentUser?.id else {
            self.errorMessage = "Usuário não autenticado"
            return
        }
        
        isSaving = true
        defer { isSaving = false }
        
        do {
            try await collageService.saveCollage(userId: userId, wordId: wordId, imageData: imageData, assets: assets)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
