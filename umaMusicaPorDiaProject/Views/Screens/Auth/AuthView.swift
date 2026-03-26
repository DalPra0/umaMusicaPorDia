import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "D9D9D9")
                .ignoresSafeArea()
            
            if viewModel.showForm {
                authFormView
            } else {
                landingView
            }
        }
    }
    
    private var landingView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            appLogo
            
            Spacer()
            
            VStack(spacing: 24) {
                AppButton(title: "Crie sua conta") {
                    viewModel.isSignUp = true
                    viewModel.showForm = true
                }
                
                AppButton(title: "Fazer login", style: .secondary) {
                    viewModel.isSignUp = false
                    viewModel.showForm = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 60)
        }
        .padding(30)
    }
    
    private var authFormView: some View {
        VStack(spacing: 60) {
            headerWithBack
            
            appLogo
            
            VStack(alignment: .leading, spacing: 24) {
                formTitle
                
                VStack(spacing: 18) {
                    if viewModel.isSignUp {
                        AppTextField(label: "usuário", placeholder: "@lunchbox", text: $viewModel.username)
                    }
                    
                    AppTextField(label: "email", placeholder: "123@icloud.com", text: $viewModel.email)
                    
                    AppTextField(label: "senha", placeholder: "********", text: $viewModel.password, isSecure: true)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                AppButton(title: viewModel.isSignUp ? "Criar" : "Entrar", isLoading: viewModel.isLoading) {
                    Task { await viewModel.handleAuth() }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    private var appLogo: some View {
        RoundedRectangle(cornerRadius: 47)
            .fill(Color(hex: "1E1E1E"))
            .frame(width: 195, height: 195)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
    
    private var headerWithBack: some View {
        HStack {
            Button(action: { viewModel.showForm = false }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "1E1E1E"))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var formTitle: some View {
        Text(viewModel.isSignUp ? "crie sua conta" : "faça login em sua conta")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(Color(hex: "4A4242"))
            .tracking(-0.43)
    }
}
