import Foundation

nonisolated
struct ITunesResponse: Codable, Sendable {
    let results: [ITunesTrack]
}

struct ITunesTrack: Codable, Sendable, Identifiable {
    var id: String { (trackName ?? "") + (artistName ?? "") }
    let trackName: String?
    let artistName: String?
    let releaseDate: String?
}

nonisolated
struct YouTubeResponse: Codable, Sendable {
    let items: [YouTubeItem]
}

struct YouTubeItem: Codable, Sendable {
    let id: VideoID
}

struct VideoID: Codable, Sendable {
    let videoId: String
}


final class MusicService: Sendable {
    func fetchTopTracks(year: Int, completion: @escaping @Sendable ([ITunesTrack], String) -> Void) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let monthString = String(format: "%02d", month)
        
        let query = "hits \(year)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(query)&country=BR&media=music&limit=30"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion([], urlString)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ITunesResponse.self, from: data)
                let filtered = response.results.filter { track in
                    track.releaseDate?.contains("\(year)") ?? false
                }
                completion(filtered.isEmpty ? response.results : filtered, urlString)
            } catch {
                completion([], urlString)
            }
        }.resume()
    }
}

final class YouTubeService: Sendable {
    private let apiKey = "AIzaSyCJe_XLTI0d0KxFXlhRFavxy4XCLX2cVNU"
    
    func fetchVideoId(q: String, completion: @escaping @Sendable (String?, String?) -> Void) {
        let query = q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&key=\(apiKey)&type=video&maxResults=1&videoEmbeddable=true"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil, urlString)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(YouTubeResponse.self, from: data)
                completion(response.items.first?.id.videoId, urlString)
            } catch {
                completion(nil, urlString)
            }
        }.resume()
    }
}
