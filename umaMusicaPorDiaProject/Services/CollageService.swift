import Foundation
import Supabase

/// Lida com o upload de imagens e salvamento de metadados das colagens
@Observable
final class CollageService {
    private let client: SupabaseClient
    
    init(client: SupabaseClient = SupabaseService.shared.client) {
        self.client = client
    }
    
    func saveCollage(userId: UUID, wordId: UUID, imageData: Data, assets: [CollageAsset]) async throws {
        let fileName = "\(userId.uuidString)/\(UUID().uuidString).jpg"
        
        // 1. Upload
        try await client.storage
            .from("user_collages")
            .upload(fileName, data: imageData, options: FileOptions(contentType: "image/jpeg"))
            
        // 2. URL
        let imageUrl = try client.storage
            .from("user_collages")
            .getPublicURL(path: fileName)
            .absoluteString
            
        // 3. Metadata
        let collage = Collage(
            id: nil,
            userId: userId,
            wordId: wordId,
            imageUrl: imageUrl,
            assetsJson: assets,
            createdAt: nil
        )
        
        try await client
            .from("user_collages")
            .insert(collage)
            .execute()
    }
    
    func fetchUserAssets(userId: UUID) async throws -> [UserAsset] {
        let response = try await client
            .from("user_assets")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            
        return try JSONDecoder().decode([UserAsset].self, from: response.data)
    }
}
