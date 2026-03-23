import Foundation

struct Collage: Codable, Identifiable {
    let id: UUID?
    let userId: UUID
    let wordId: UUID
    let imageUrl: String
    let assetsJson: [CollageAsset]
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case wordId = "word_id"
        case imageUrl = "image_url"
        case assetsJson = "assets_json"
        case createdAt = "created_at"
    }
}

struct CollageAsset: Codable {
    let id: String
    let x: Double
    let y: Double
    let scale: Double
    let rotation: Double
    let type: String
}
