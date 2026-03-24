import Foundation
import Combine
import Supabase

class MusicViewModel: ObservableObject {
    @Published var trackName: String = "Carregando..."
    @Published var artistName: String = ""
    @Published var videoId: String?
    @Published var selectedYear: Int = 0
    @Published var selectedDayMonth: String = ""
    
    @Published var dailyWord: DailyWord?
    @Published var isLoadingWord: Bool = false
    @Published var errorMessage: String?
    
    @Published var tracksFound: [ITunesTrack] = []
    @Published var appleMusicUrl: String = ""
    
    private let musicService = MusicService()
    private let youtubeService = YouTubeService()
    private let supabaseService = SupabaseService.shared
    
    func loadInitialData() {
        Task {
            await fetchDailyWord()
            loadDailyNostalgia()
        }
    }
    
    @MainActor
    func fetchDailyWord() async {
        isLoadingWord = true
        do {
            self.dailyWord = try await supabaseService.fetchDailyWord()
        } catch {
            print("DEBUG: Nenhuma palavra para hoje. Tentando sortear uma nova...")
            // Tenta sortear uma se não houver nenhuma
            await refreshWord()
        }
        isLoadingWord = false
    }
    
    @MainActor
    func refreshWord() async {
        isLoadingWord = true
        dailyWord = nil // Limpa para dar o efeito de carregamento
        do {
            try await supabaseService.refreshDailyWord()
            // Aguarda 1 segundo para o banco processar a mudança
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await fetchDailyWord()
        } catch {
            self.errorMessage = "Erro ao sortear: \(error.localizedDescription)"
        }
        isLoadingWord = false
    }
    
    func loadDailyNostalgia() {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        let month = calendar.component(.month, from: Date())
        let year = Int.random(in: 2000...2016)
        
        self.selectedYear = year
        self.selectedDayMonth = "\(day)/\(month)"
        self.videoId = nil
        
        musicService.fetchTopTracks(year: year) { tracks, url in
            DispatchQueue.main.async {
                self.tracksFound = tracks
                self.appleMusicUrl = url
                
                if let randomTrack = tracks.randomElement(),
                   let name = randomTrack.trackName,
                   let artist = randomTrack.artistName {
                    self.trackName = name
                    self.artistName = artist
                    
                    self.youtubeService.fetchVideoId(q: "\(name) \(artist) official music video") { vId, _ in
                        DispatchQueue.main.async {
                            self.videoId = vId
                        }
                    }
                } else {
                    self.trackName = "Nenhum hit encontrado em \(year)"
                }
            }
        }
    }
    
    func saveUserCollage(imageData: Data, assets: [CollageAsset]) async {
        guard let wordId = dailyWord?.id else { return }
        do {
            try await supabaseService.saveCollage(wordId: wordId, imageData: imageData, assets: assets)
            print("Colagem salva com sucesso!")
        } catch {
            print("Erro ao salvar colagem: \(error)")
        }
    }
}
