import Foundation
import Combine

class MusicViewModel: ObservableObject {
    @Published var trackName: String = "Carregando..."
    @Published var artistName: String = ""
    @Published var videoId: String?
    @Published var selectedYear: Int = 0
    
    // Debug info
    @Published var lastFMUrl: String = ""
    @Published var youtubeUrl: String = ""
    
    private let musicService = MusicService()
    private let youtubeService = YouTubeService()
    
    func loadDailyNostalgia() {
        let year = Int.random(in: 2000...2016)
        self.selectedYear = year
        self.videoId = nil
        
        musicService.fetchTopTrack(year: year) { name, artist, url in
            DispatchQueue.main.async {
                self.lastFMUrl = url ?? ""
                if let name = name, let artist = artist {
                    self.trackName = name
                    self.artistName = artist
                    
                    self.youtubeService.fetchVideoId(q: "\(name) \(artist) official music video") { vId, ytUrl in
                        DispatchQueue.main.async {
                            self.videoId = vId
                            self.youtubeUrl = ytUrl ?? ""
                        }
                    }
                } else {
                    self.trackName = "Erro ao carregar música"
                }
            }
        }
    }
}
