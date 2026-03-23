import Foundation

struct DailyWord: Codable, Identifiable {
    let id: UUID
    let word: String
    let createdAt: String // Mudamos para String para ser mais robusto na decodificação
    
    enum CodingKeys: String, CodingKey {
        case id
        case word
        case createdAt = "created_at"
    }
}
