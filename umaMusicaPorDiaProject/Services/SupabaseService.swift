import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    // Inicialização direta do cliente
    let client = SupabaseClient(
        supabaseURL: SupabaseConfig.url,
        supabaseKey: SupabaseConfig.anonKey
    )
    
    private init() {}
    
    // 1. Login Anônimo (Necessário para a política RLS)
    // 1. Autenticação Real
    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }

    var currentUser: User? {
        return client.auth.currentSession?.user
    }

    // 2. Buscar a palavra do dia (Usando decodificação manual de dados para evitar erros de tipo)
    func fetchDailyWord() async throws -> DailyWord {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())
        
        print("DEBUG: Buscando palavra para a data: \(today)")
        
        // Fazer a busca
        let response = try await client
            .from("daily_words")
            .select()
            .eq("created_at", value: today)
            .single()
            .execute()
        
        // Decodificar manualmente o JSON para garantir que não haja erro de conversão
        let word = try JSONDecoder().decode(DailyWord.self, from: response.data)
        
        print("DEBUG: Palavra encontrada com sucesso: \(word.word)")
        return word
    }

    // 2.1 Forçar sorteio de nova palavra (RPC)
    func refreshDailyWord() async throws {
        print("DEBUG: Chamando RPC generate_daily_word...")
        try await client.rpc("generate_daily_word").execute()
    }
    
    // 4. Buscar assets coletados pelo usuário
    func fetchUserAssets() async throws -> [UserAsset] {
        guard let userId = currentUser?.id else { return [] }
        
        let response = try await client
            .from("user_assets")
            .select()
            .eq("user_id", value: userId.uuidString)
            .order("created_at", ascending: false)
            .execute()
            
        return try JSONDecoder().decode([UserAsset].self, from: response.data)
    }

    // 5. Salvar colagem (Imagem + Dados)
    func saveCollage(wordId: UUID, imageData: Data, assets: [CollageAsset]) async throws {
        guard let userId = currentUser?.id else {
            throw NSError(domain: "SupabaseService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado"])
        }
        
        // 1. Upload da imagem para o bucket 'user_collages'
        let fileName = "\(userId.uuidString)/\(UUID().uuidString).jpg"
        
        try await client.storage
            .from("user_collages")
            .upload(
                fileName,
                data: imageData,
                options: FileOptions(contentType: "image/jpeg")
            )
            
        // 2. Pegar URL Pública
        let imageUrl = try client.storage
            .from("user_collages")
            .getPublicURL(path: fileName)
            .absoluteString
            
        // 3. Salvar na tabela 'user_collages'
        // Criamos o objeto Collage para garantir a codificação correta
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
            
        print("DEBUG: Colagem salva com sucesso para o usuário \(userId)")
    }
}
