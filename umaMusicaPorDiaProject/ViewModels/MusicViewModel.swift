import Foundation
import Combine

class MusicViewModel: ObservableObject {
    @Published var trackName: String = "Carregando..."
    @Published var artistName: String = ""
    @Published var videoId: String?
    @Published var selectedYear: Int = 0
    @Published var selectedDayMonth: String = ""
    
    @Published var tracksFound: [ITunesTrack] = []
    @Published var appleMusicUrl: String = ""
    
    private let musicService = MusicService()
    private let youtubeService = YouTubeService()
    
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
}
