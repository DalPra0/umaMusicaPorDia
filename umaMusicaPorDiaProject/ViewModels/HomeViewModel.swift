import SwiftUI
import Auth

@Observable
final class HomeViewModel {
    // Serviços
    private let wordService: WordService
    private let authService: AuthService
    
    // Estados da UI (State-as-Bridge)
    var dailyWord: DailyWord?
    var username: String = "Usuário"
    var isSpinning = false
    var wordsOffset: CGFloat = 0
    var leverPull: CGFloat = 0
    var errorMessage: String?
    
    // Dados Fixos
    let placeholderWords = ["INFÂNCIA", "AMOR", "VIAGEM", "SONHO", "FESTA", "VERÃO", "AMIGOS", "NOSTALGIA"]
    private let itemHeight: CGFloat = 80
    
    init(wordService: WordService = WordService(), authService: AuthService = AuthService()) {
        self.wordService = wordService
        self.authService = authService
        fetchInitialData()
    }
    
    func fetchInitialData() {
        updateUsername()
        Task {
            await loadDailyWord()
        }
    }
    
    private func updateUsername() {
        if let email = authService.currentUser?.email {
            username = email.components(separatedBy: "@").first ?? "Usuário"
        }
    }
    
    @MainActor
    func loadDailyWord() async {
        do {
            self.dailyWord = try await wordService.fetchDailyWord()
        } catch {
            print("DEBUG: Nenhuma palavra para hoje. Tentando gerar...")
            await refreshWord()
        }
    }
    
    @MainActor
    func refreshWord() async {
        do {
            try await wordService.refreshDailyWord()
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            self.dailyWord = try await wordService.fetchDailyWord()
        } catch {
            self.errorMessage = "Erro ao sortear: \(error.localizedDescription)"
        }
    }
    
    func spin() {
        guard !isSpinning else { return }
        
        // 1. Inicia animação da alavanca (Síncrono para UI)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
            leverPull = 50
            isSpinning = true
        }
        
        // 2. Dispara a lógica de rotação
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                self.leverPull = 0
            }
            
            self.executeSpinRotation()
        }
    }
    
    private func executeSpinRotation() {
        let totalItems = placeholderWords.count
        let finalOffset = -(CGFloat(totalItems) * itemHeight)
        
        if dailyWord != nil {
            withAnimation(.easeInOut(duration: 2.5)) {
                wordsOffset = finalOffset
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.isSpinning = false
            }
        } else {
            // Spin infinito enquanto carrega
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                wordsOffset = -(CGFloat(placeholderWords.count - 1) * itemHeight)
            }
            
            Task {
                await loadDailyWord()
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        wordsOffset = finalOffset
                    }
                    self.isSpinning = false
                }
            }
        }
    }
    
    func signOut() async {
        try? await authService.signOut()
    }
}
