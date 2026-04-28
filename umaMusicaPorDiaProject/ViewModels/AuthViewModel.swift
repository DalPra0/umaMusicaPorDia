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

    var showEmailVerificationSheet = false
    var didTapTermsLink = false
    var didCheckEmailVerification = false

    var pendingEmailVerification: Bool {
        get { UserDefaults.standard.bool(forKey: "pendingEmailVerification") }
        set { UserDefaults.standard.set(newValue, forKey: "pendingEmailVerification") }
    }

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
                pendingEmailVerification = true
                didTapTermsLink = false
                didCheckEmailVerification = false
                showEmailVerificationSheet = true
            } else {
                try await authService.signIn(email: email, password: password)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func confirmEmailVerification() {
        pendingEmailVerification = false
        showEmailVerificationSheet = false
        didTapTermsLink = false
        didCheckEmailVerification = false
        isSignUp = false
        showForm = true
        email = ""
        password = ""
        username = ""
        errorMessage = nil
    }

    func resetForm() {
        email = ""
        password = ""
        username = ""
        errorMessage = nil
    }
}
