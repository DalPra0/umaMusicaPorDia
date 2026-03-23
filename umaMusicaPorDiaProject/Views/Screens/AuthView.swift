import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    let supabase = SupabaseService.shared
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎵 Nostalgia App")
                .font(.system(size: 40, weight: .black, design: .serif))
                .italic()
                .foregroundColor(.purple)
            
            Text(isSignUp ? "Crie sua conta" : "Bem-vindo de volta")
                .font(.headline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Senha", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Button(action: handleAuth) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(isSignUp ? "Cadastrar" : "Entrar")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .disabled(isLoading)
            
            Button(action: { isSignUp.toggle() }) {
                Text(isSignUp ? "Já tem conta? Faça login" : "Não tem conta? Cadastre-se")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
    
    func handleAuth() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                if isSignUp {
                    try await supabase.signUp(email: email, password: password)
                    errorMessage = "Verifique seu email para confirmar o cadastro!"
                } else {
                    try await supabase.signIn(email: email, password: password)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
