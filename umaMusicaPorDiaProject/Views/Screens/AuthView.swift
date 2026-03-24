import SwiftUI

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = "" // Novo campo para o Cadastro
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // Estado para controlar se estamos na tela inicial (Landing) ou no formulário
    @State private var showForm = false
    
    let supabase = SupabaseService.shared
    
    var body: some View {
        ZStack {
            Color(hex: "D9D9D9")
                .ignoresSafeArea()
            
            if showForm {
                formView
            } else {
                landingView
            }
        }
    }
    
    // MARK: - Landing View (O design do Figma 1)
    var landingView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Logo / App Icon Placeholder
            RoundedRectangle(cornerRadius: 47)
                .fill(Color(hex: "1E1E1E"))
                .frame(width: 195, height: 195)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            
            Spacer()
            
            VStack(spacing: 24) {
                // Botão Criar Conta
                Button(action: {
                    isSignUp = true
                    showForm = true
                }) {
                    Text("Crie sua conta")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 43)
                        .background(Color(hex: "3B3939"))
                        .cornerRadius(12)
                }
                
                // Botão Fazer Login
                Button(action: {
                    isSignUp = false
                    showForm = true
                }) {
                    Text("Fazer login")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "090909"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 43)
                        .background(Color.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 60)
        }
        .padding(30)
    }
    
    // MARK: - Form View (Login/Cadastro - Design Figma 2 & 3)
    var formView: some View {
        VStack(spacing: 60) {
            // Header com Botão de Voltar
            HStack {
                Button(action: { showForm = false }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "1E1E1E"))
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Logo / App Icon Placeholder
            RoundedRectangle(cornerRadius: 47)
                .fill(Color(hex: "1E1E1E"))
                .frame(width: 195, height: 195)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            
            // Formulário
            VStack(alignment: .leading, spacing: 24) {
                
                // Título
                Text(isSignUp ? "crie sua conta" : "faça login em sua conta")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "4A4242"))
                    .tracking(-0.43)
                
                // Campos
                VStack(spacing: 18) {
                    
                    // Campo Usuário (Apenas no Cadastro - Figma node 96:65)
                    if isSignUp {
                        HStack {
                            Text("usuário")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                                .frame(width: 80, alignment: .leading)
                            
                            TextField("@lunchbox", text: $username)
                                .font(.system(size: 17))
                                .foregroundColor(.gray)
                                .autocapitalization(.none)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 44)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    
                    // Campo Email
                    HStack {
                        Text("email")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                            .frame(width: 80, alignment: .leading)
                        
                        TextField("123@icloud.com", text: $email)
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Campo Senha
                    HStack {
                        Text("senha")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                            .frame(width: 80, alignment: .leading)
                        
                        SecureField("********", text: $password)
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                // Botão de Ação
                Button(action: handleAuth) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .frame(height: 43)
                            .background(Color(hex: "3B3939"))
                            .cornerRadius(12)
                    } else {
                        Text(isSignUp ? "Criar" : "Entrar")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .tracking(-0.23)
                            .frame(maxWidth: .infinity)
                            .frame(height: 43)
                            .background(Color(hex: "3B3939"))
                            .cornerRadius(12)
                    }
                }
                .disabled(isLoading)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    func handleAuth() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                if isSignUp {
                    // Nota: Se o Supabase precisar de metadados para o username, podemos passar aqui
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

// Helper para cores Hex (mantido)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
