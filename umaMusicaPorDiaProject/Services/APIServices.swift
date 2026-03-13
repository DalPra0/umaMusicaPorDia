import Foundation

struct ITunesResponse: Codable, Sendable {
    let results: [ITunesTrack]
}

struct ITunesTrack: Codable, Sendable {
    let trackName: String?
    let artistName: String?
    let releaseDate: String?
    let primaryGenreName: String?
}

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
    func fetchTopTrack(year: Int, completion: @escaping @Sendable (String?, String?, String?) -> Void) {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let monthString = String(format: "%02d", month)
        
        // Buscamos músicas que estavam em evidência naquele mês/ano no Brasil
        // Usamos um termo de busca que força o iTunes a olhar para o catálogo histórico
        let query = "hits \(monthString) \(year)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(query)&country=BR&media=music&limit=50&explicit=Yes"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil, nil, urlString)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ITunesResponse.self, from: data)
                
                // Filtramos para pegar músicas que REALMENTE são daquela época
                // O iTunes traz muita coisa, então validamos a releaseDate
                let filtered = response.results.filter { track in
                    guard let date = track.releaseDate else { return false }
                    return date.contains("\(year)-\(monthString)") || date.contains("\(year)")
                }
                
                let track = filtered.randomElement() ?? response.results.randomElement()
                completion(track?.trackName, track?.artistName, urlString)
            } catch {
                completion(nil, nil, urlString)
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
