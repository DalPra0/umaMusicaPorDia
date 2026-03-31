import SwiftUI

@Observable
final class AuthViewModel {
    private let authService: AuthService
    
    var email = ""
    var password = ""
    var username = ""
    var isSignUp = false
    var isLoading = false
    var errorMessage: String?
    var showForm = false
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    @MainActor
    func handleAuth() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            if isSignUp {
                try await authService.signUp(email: email, password: password)
                errorMessage = "Verifique seu email para confirmar o cadastro!"
            } else {
                try await authService.signIn(email: email, password: password)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func resetForm() {
        email = ""
        password = ""
        username = ""
        errorMessage = nil
    }
}
