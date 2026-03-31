import Foundation

struct UserAsset: Codable, Identifiable {
    let id: UUID
    let userId: String
    let imageUrl: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
