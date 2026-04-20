import SwiftUI
import Auth

@Observable
final class HomeViewModel {
    private let wordService: WordService
    private let authService: AuthService
    
    var dailyWord: DailyWord?
    var username: String = "Usuário"
    var isSpinning = false
    var slotWords: [String] = ["SORTEAR"]
    var wordsOffset: CGFloat = 0
    var leverPull: CGFloat = 0
    var errorMessage: String?
    
    let placeholderWords = ["INFÂNCIA", "AMOR", "VIAGEM", "SONHO", "FESTA", "VERÃO", "AMIGOS", "NOSTALGIA"]
    private var wordPool: [String] = []
    private let itemHeight: CGFloat = 60
    private let minimumSpinWords = 28
    
    init(wordService: WordService = WordService(), authService: AuthService = AuthService()) {
        self.wordService = wordService
        self.authService = authService
        fetchInitialData()
    }
    
    func fetchInitialData() {
        updateUsername()
        Task {
            await loadDailyWord()
            await loadWordPool()
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
            updateIdleVisorWordIfNeeded()
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
            updateIdleVisorWordIfNeeded()
        } catch {
            self.errorMessage = "Erro ao sortear: \(error.localizedDescription)"
        }
    }

    @MainActor
    func loadWordPool() async {
        do {
            let fetchedWords = try await wordService.fetchWordPool()
            wordPool = uniqueWords(from: fetchedWords + placeholderWords)
            if let dailyWord {
                wordPool = uniqueWords(from: wordPool + [dailyWord.word.uppercased()])
            }
        } catch {
            wordPool = uniqueWords(from: placeholderWords)
        }
    }
    
    func spin() {
        guard !isSpinning else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
            leverPull = 50
            isSpinning = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                self.leverPull = 0
            }
            
            Task { @MainActor in
                await self.executeSpinRotation()
            }
        }
    }
    
    @MainActor
    private func executeSpinRotation() async {
        if dailyWord == nil {
            await loadDailyWord()
        }

        guard let targetWord = dailyWord?.word.uppercased() else {
            isSpinning = false
            errorMessage = "Não foi possível carregar a palavra do dia."
            return
        }

        if wordPool.isEmpty {
            await loadWordPool()
        }

        slotWords = buildSpinSequence(targetWord: targetWord)
        wordsOffset = 0

        let finalIndex = max(slotWords.count - 1, 0)
        let finalOffset = -CGFloat(finalIndex) * itemHeight
        let intermediateIndex = max(finalIndex - 6, Int(Double(finalIndex) * 0.72))
        let intermediateOffset = -CGFloat(intermediateIndex) * itemHeight
        let firstPhaseDuration = 1.7
        let secondPhaseDuration = 1.1
        let totalDuration = firstPhaseDuration + secondPhaseDuration

        Task { @MainActor in
            await HapticsManager.shared.playSpinDecelerationPattern(duration: totalDuration)
        }

        withAnimation(.linear(duration: firstPhaseDuration)) {
            wordsOffset = intermediateOffset
        }

        try? await Task.sleep(nanoseconds: UInt64(firstPhaseDuration * 1_000_000_000))

        withAnimation(.easeOut(duration: secondPhaseDuration)) {
            wordsOffset = finalOffset
        }

        try? await Task.sleep(nanoseconds: UInt64(secondPhaseDuration * 1_000_000_000))
        isSpinning = false
    }

    private func buildSpinSequence(targetWord: String) -> [String] {
        let pool = uniqueWords(from: wordPool + placeholderWords + [targetWord])
        guard !pool.isEmpty else { return [targetWord] }

        var sequence: [String] = []
        while sequence.count < minimumSpinWords {
            sequence.append(pool.randomElement() ?? targetWord)
        }

        for _ in 0..<6 {
            sequence.append(pool.randomElement() ?? targetWord)
        }

        sequence.append(targetWord)
        return sequence
    }

    @MainActor
    private func updateIdleVisorWordIfNeeded() {
        guard !isSpinning else { return }
        guard let word = dailyWord?.word.uppercased() else {
            slotWords = ["SORTEAR"]
            wordsOffset = 0
            return
        }

        slotWords = [word]
        wordsOffset = 0
    }

    private func uniqueWords(from words: [String]) -> [String] {
        var seen = Set<String>()
        var unique: [String] = []

        for word in words {
            let normalized = word.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            guard !normalized.isEmpty, !seen.contains(normalized) else { continue }
            seen.insert(normalized)
            unique.append(normalized)
        }

        return unique
    }
    
    @MainActor
    func signOut() async -> Bool {
        do {
            try await authService.signOut()
            return true
        } catch {
            errorMessage = "Não foi possível sair da conta: \(error.localizedDescription)"
            return false
        }
    }
}
