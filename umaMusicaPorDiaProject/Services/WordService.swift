import Foundation
import Supabase

/// Busca e gerencia as palavras do dia
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
}
