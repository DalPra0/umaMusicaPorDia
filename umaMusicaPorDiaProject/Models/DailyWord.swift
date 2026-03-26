import Foundation

struct DailyWord: Codable, Identifiable, Equatable {
    let id: UUID
    let word: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case word
        case createdAt = "created_at"
    }
}
