import Foundation
import Supabase

@Observable
final class WordService {
    private let client: SupabaseClient
    
    init(client: SupabaseClient = SupabaseService.shared.client) {
        self.client = client
    }
    
    func fetchDailyWord() async throws -> DailyWord {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        let response = try await client
            .from("daily_words")
            .select()
            .eq("created_at", value: today)
            .single()
            .execute()
        
        return try JSONDecoder().decode(DailyWord.self, from: response.data)
    }
    
    func refreshDailyWord() async throws {
        try await client.rpc("generate_daily_word").execute()
    }

    func fetchWordPool(limit: Int = 40) async throws -> [String] {
        struct WordRow: Decodable {
            let word: String
        }

        let response = try await client
            .from("daily_words")
            .select("word")
            .order("created_at", ascending: false)
            .limit(limit)
            .execute()

        let rows = try JSONDecoder().decode([WordRow].self, from: response.data)
        return rows
            .map { $0.word.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() }
            .filter { !$0.isEmpty }
    }
}
