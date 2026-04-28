import Foundation
import Supabase
import Auth

@Observable
final class AuthService {
    enum AuthServiceError: LocalizedError {
        case missingAuthenticatedUser
        case accountDeletionFailed

        var errorDescription: String? {
            switch self {
            case .missingAuthenticatedUser:
                return "Nenhuma conta autenticada foi encontrada."
            case .accountDeletionFailed:
                return "Não foi possível excluir sua conta agora. Tente novamente em instantes."
            }
        }
    }

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

    func deleteCurrentAccount() async throws {
        guard currentUser != nil else {
            throw AuthServiceError.missingAuthenticatedUser
        }

        do {
            try await client.rpc("delete_user").execute()
        } catch {
            throw AuthServiceError.accountDeletionFailed
        }

        // Limpa o estado local após a remoção no backend.
        try? await client.auth.signOut()
    }
}
