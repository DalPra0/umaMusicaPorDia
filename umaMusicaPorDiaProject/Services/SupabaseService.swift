import Foundation
import Supabase

/// Gerenciador central do cliente Supabase.
/// Fornece o cliente configurado para os serviços especializados.
/// Usa SharedSupabaseClient para compartilhar sessão entre app e extensões.
class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    
    private init() {
        self.client = SharedSupabaseClient.shared.client
    }
}
