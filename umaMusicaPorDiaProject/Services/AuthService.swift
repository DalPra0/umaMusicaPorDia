import Foundation
import Supabase
import Auth

/// Gerencia a autenticação com o Supabase
@Observable
final class AuthService {
    private let client: SupabaseClient
    
    var currentUser: User? { client.auth.currentSession?.user }
    
    init(client: SupabaseClient = SupabaseService.shared.client) {
        self.client = client
    }
    
    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
}
