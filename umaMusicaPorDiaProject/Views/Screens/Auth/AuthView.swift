import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()

    private enum LoginField: Hashable { case email, password }
    private enum SignUpField: Hashable { case username, email, password }

    @FocusState private var loginFocusedField: LoginField?
    @FocusState private var signUpFocusedField: SignUpField?

    var body: some View {
        Group {
            if viewModel.showForm {
                if viewModel.isSignUp {
                    createAccountView
                } else {
                    ZStack {
                        Color(hex: "D9D9D9")
                            .ignoresSafeArea()
                        loginFormView
                    }
                }
            } else {
                landingView
            }
        }
        .onAppear {
            if viewModel.pendingEmailVerification {
                viewModel.showEmailVerificationSheet = true
            }
        }
        .sheet(
            isPresented: Binding(
                get: { viewModel.showEmailVerificationSheet },
                set: { viewModel.showEmailVerificationSheet = $0 }
            ),
            onDismiss: {
                viewModel.didTapTermsLink = false
                viewModel.didCheckEmailVerification = false
            }
        ) {
            EmailVerificationSheet(viewModel: viewModel)
        }
    }

    // MARK: - Landing

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

    // MARK: - Login Form

    private var loginFormView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color(hex: "81E862")
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [Color(hex: "6759F1").opacity(0), Color(hex: "6759F1")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: max(420, geometry.size.height * 0.72))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)

                Color.white
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(edges: .top)

                ScrollView {
                    VStack(spacing: 0) {
                        headerWithBack

                        Spacer().frame(height: 70)

                        Image("LogoBentoAmarelo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 331, height: 159)
                            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)

                        Spacer().frame(height: 45)

                        VStack(alignment: .leading, spacing: 18) {
                            Text("faça login em sua conta")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color(hex: "FC02B2"))
                                .tracking(-0.43)

                            createAccountField(
                                label: "email",
                                placeholder: "123@icloud.com",
                                text: Binding(
                                    get: { viewModel.email },
                                    set: { viewModel.email = $0 }
                                )
                            )
                            .focused($loginFocusedField, equals: .email)

                            createAccountField(
                                label: "senha",
                                placeholder: "********",
                                text: Binding(
                                    get: { viewModel.password },
                                    set: { viewModel.password = $0 }
                                ),
                                isSecure: true
                            )
                            .focused($loginFocusedField, equals: .password)

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .padding(.top, -6)
                            }

                            Button {
                                Task { await viewModel.handleAuth() }
                            } label: {
                                Text("Entrar")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                                    .tracking(-0.23)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 43)
                                    .background(Color(hex: "FC02B2"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(viewModel.isLoading)
                            .overlay {
                                if viewModel.isLoading {
                                    ProgressView().tint(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer().frame(height: 60)
                    }
                }
                .scrollDismissesKeyboard(.interactively)

                if loginFocusedField != nil {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture { loginFocusedField = nil }
                        .ignoresSafeArea()
                }
            }
        }
    }

    // MARK: - Create Account Form

    private var createAccountView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color(hex: "81E862")
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [Color(hex: "6759F1").opacity(0), Color(hex: "6759F1")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: max(420, geometry.size.height * 0.72))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)

                Color.white
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(edges: .top)

                ScrollView {
                    VStack(spacing: 0) {
                        headerWithBack

                        Spacer().frame(height: 70)

                        Image("LogoBentoRosa")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 307, height: 159)
                            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)

                        Spacer().frame(height: 72)

                        VStack(alignment: .leading, spacing: 14) {
                            Text("crie sua conta")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color(hex: "FC02B2"))
                                .tracking(-0.43)

                            createAccountField(
                                label: "usuário",
                                placeholder: "@lunchbox",
                                text: Binding(
                                    get: { viewModel.username },
                                    set: { viewModel.username = $0 }
                                )
                            )
                            .focused($signUpFocusedField, equals: .username)

                            createAccountField(
                                label: "email",
                                placeholder: "123@icloud.com",
                                text: Binding(
                                    get: { viewModel.email },
                                    set: { viewModel.email = $0 }
                                )
                            )
                            .focused($signUpFocusedField, equals: .email)

                            createAccountField(
                                label: "senha",
                                placeholder: "********",
                                text: Binding(
                                    get: { viewModel.password },
                                    set: { viewModel.password = $0 }
                                ),
                                isSecure: true
                            )
                            .focused($signUpFocusedField, equals: .password)

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                                    .padding(.top, 4)
                            }

                            Button {
                                Task { await viewModel.handleAuth() }
                            } label: {
                                Text("Criar")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                                    .tracking(-0.23)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 43)
                                    .background(Color(hex: "FC02B2"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(viewModel.isLoading)
                            .overlay {
                                if viewModel.isLoading {
                                    ProgressView().tint(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        Spacer().frame(height: 60)
                    }
                }
                .scrollDismissesKeyboard(.interactively)

                if signUpFocusedField != nil {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture { signUpFocusedField = nil }
                        .ignoresSafeArea()
                }
            }
        }
    }

    // MARK: - Shared Components

    private var landingLogo: some View {
        Image("LogoBentoVerde")
            .resizable()
            .scaledToFit()
            .frame(width: 307, height: 159)
            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)
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

    private func createAccountField(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 17))
                .foregroundStyle(.black)
                .frame(width: 100, alignment: .leading)

            if isSecure {
                SecureField(placeholder, text: text)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.black.opacity(0.35))
                    .textInputAutocapitalization(.never)
            } else {
                TextField(placeholder, text: text)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.black.opacity(0.35))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 45)
        .background(Color(hex: "D8FFCC"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Email Verification Sheet

struct EmailVerificationSheet: View {
    var viewModel: AuthViewModel

    private var attributedTermsText: AttributedString {
        let raw = "Para criar sua conta, verifique seu e-mail e aceite os [termos de serviço](https://dalpra0.github.io/BentoWebsite/)."
        return (try? AttributedString(markdown: raw)) ?? AttributedString(raw)
    }

    var body: some View {
        VStack(spacing: 28) {
            Image("LogoBentoRoxo")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 60)
                .padding(.top, 8)

            Text("Quase lá!")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(hex: "6759F1"))

            Text(attributedTermsText)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .environment(\.openURL, OpenURLAction { _ in
                    viewModel.didTapTermsLink = true
                    return .systemAction
                })

            Toggle(isOn: Binding(
                get: { viewModel.didCheckEmailVerification },
                set: { viewModel.didCheckEmailVerification = $0 }
            )) {
                Text("Verifiquei meu e-mail")
                    .font(.system(size: 16))
            }
            .tint(Color(hex: "6759F1"))
            .padding(.horizontal, 8)

            Button {
                viewModel.confirmEmailVerification()
            } label: {
                Text("Confirmar")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 43)
                    .background(
                        (viewModel.didTapTermsLink && viewModel.didCheckEmailVerification)
                            ? Color(hex: "FC02B2")
                            : Color(hex: "FC02B2").opacity(0.3)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!viewModel.didTapTermsLink || !viewModel.didCheckEmailVerification)

            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.top, 32)
        .presentationDetents([.medium])
    }
}
