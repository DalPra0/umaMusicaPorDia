import Foundation

struct UserAsset: Codable, Identifiable {
    let id: UUID
    let userId: String // Mudado para String pois o banco pode retornar fallback UUID ou ID real
    let imageUrl: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
