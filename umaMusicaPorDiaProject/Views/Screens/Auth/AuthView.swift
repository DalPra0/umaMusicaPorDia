import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    
    var body: some View {
        if viewModel.showForm {
            ZStack {
                Color(hex: "D9D9D9")
                    .ignoresSafeArea()
                authFormView
            }
        } else {
            landingView
        }
    }
    
    private var landingView: some View {
        ZStack(alignment: .top) {
            Color(hex: "6759F1")
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [Color(hex: "81E862").opacity(0), Color(hex: "81E862")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            VStack(spacing: 96) {
                landingLogo
                
                VStack(spacing: 24) {
                    landingPrimaryButton(title: "Crie sua conta") {
                        viewModel.isSignUp = true
                        viewModel.showForm = true
                    }
                    
                    landingSecondaryButton(title: "Fazer login") {
                        viewModel.isSignUp = false
                        viewModel.showForm = true
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 246)
            .padding(.horizontal, 20)
        }
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
    
    private var landingLogo: some View {
        Image("LogoBentoVerde")
            .resizable()
            .scaledToFit()
            .frame(width: 307, height: 159)
            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)
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

    private func landingPrimaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .tracking(-0.23)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 43)
                .background(Color(hex: "FC02B2"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .shadow(color: .black.opacity(0.13), radius: 5.4, x: 0, y: 4)
    }

    private func landingSecondaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .tracking(-0.23)
                .foregroundStyle(Color(hex: "FC02B2"))
                .frame(maxWidth: .infinity)
                .frame(height: 43)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "FC02B2"), lineWidth: 4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}
