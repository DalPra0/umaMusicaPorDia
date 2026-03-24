import SwiftUI
import Auth

struct HomeView: View {
    @StateObject private var viewModel = MusicViewModel()
    @State private var navigateToCollage = false
    @State private var showSettings = false
    
    // Animação da "Slot Machine"
    @State private var wordsOffset: CGFloat = 0
    @State private var isSpinning = false
    @State private var selectedWordIndex = 0
    
    // Animação da Alavanca
    @State private var leverPull: CGFloat = 0
    
    // O nome de usuário para mostrar na tela
    @State private var username: String = "Usuário"
    
    // Lista de palavras fictícias para a animação antes de parar na palavra real
    let placeholderWords = ["INFÂNCIA", "AMOR", "VIAGEM", "SONHO", "FESTA", "VERÃO", "AMIGOS", "NOSTALGIA"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "D9D9D9")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // 1. Header (Configurações)
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // 2. A Máquina do Tempo Central
                    timeMachineView
                    
                    Spacer()
                    
                    // 3. Botão Continuar
                    Button(action: {
                        if !isSpinning && viewModel.dailyWord != nil {
                            navigateToCollage = true
                        } else if !isSpinning {
                            startSpinningAnimation()
                        }
                    }) {
                        Text(isSpinning ? "Sorteando..." : (viewModel.dailyWord != nil ? "Continuar" : "Girar Máquina"))
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .tracking(-0.23)
                            .frame(maxWidth: .infinity)
                            .frame(height: 43)
                            .background(Color(hex: "3B3939"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .disabled(isSpinning)
                }
            }
            .navigationDestination(isPresented: $navigateToCollage) {
                CollageCreatorView()
            }
            .sheet(isPresented: $showSettings) {
                settingsSheet
            }
            .onAppear {
                viewModel.loadInitialData()
                fetchUsername()
                
                // Se ainda não tiver uma palavra carregada ou se quisermos animar ao entrar
                if viewModel.dailyWord == nil {
                    // Espera um pouco e inicia a animação se for a primeira vez
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        startSpinningAnimation()
                    }
                }
            }
            // Quando a palavra do dia for carregada, garante que a animação pare nela
            .onChange(of: viewModel.dailyWord) { _, newWord in
                if newWord != nil && !isSpinning {
                    // Já temos a palavra, ajusta para o estado final
                    selectedWordIndex = placeholderWords.count
                }
            }
        }
    }
    
    // MARK: - A Máquina do Tempo
    private var timeMachineView: some View {
        ZStack {
            // O Console Escuro
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "1E1E1E"))
                .frame(width: 341, height: 444)
                .shadow(color: .black.opacity(0.2), radius: 15, y: 10)
            
            // O Visor Branco (Slot)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 302, height: 220)
                .offset(y: -70) // Posiciona o visor mais para cima
            
            // Textos Girando no Visor
            // Usamos mask para "cortar" as palavras que estão fora do visor branco
            GeometryReader { geometry in
                let visorHeight: CGFloat = 220
                let itemHeight: CGFloat = 80 // Altura de cada palavra
                
                VStack(spacing: 0) {
                    // Palavras fakes para o efeito de girar
                    ForEach(0..<placeholderWords.count, id: \.self) { index in
                        Text(placeholderWords[index])
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color(hex: "1E1E1E"))
                            .tracking(0.4)
                            .frame(height: itemHeight)
                    }
                    
                    // A palavra Real (do banco de dados)
                    if let realWord = viewModel.dailyWord?.word.uppercased() {
                        Text(realWord)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color(hex: "1E1E1E"))
                            .tracking(0.4)
                            .frame(height: itemHeight)
                    } else {
                        Text("...")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(Color(hex: "1E1E1E"))
                            .tracking(0.4)
                            .frame(height: itemHeight)
                    }
                }
                .offset(y: wordsOffset)
                // Centraliza inicialmente o primeiro item no visor
                .position(x: geometry.size.width / 2, y: visorHeight / 2 - itemHeight / 2)
            }
            .frame(width: 302, height: 220)
            .offset(y: -70)
            .mask(
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 302, height: 220)
                    .offset(y: -70)
            )
            
            // O Nome de Usuário
            Text(username)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .tracking(0.4)
                .offset(y: 110)
            
            // --- A Alavanca ---
            leverView
                .offset(x: 130, y: 50)
        }
    }
    
    private var leverView: some View {
        ZStack {
            // Base da alavanca (buraco)
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "D9D9D9").opacity(0.3)) // Um pouco translúcido para parecer um buraco
                .frame(width: 23, height: 96)
            
            // O pino da alavanca
            ZStack {
                // Haste
                RoundedRectangle(cornerRadius: 19)
                    .fill(Color(hex: "6C6063"))
                    .frame(width: 8, height: 82)
                    .offset(y: 20) // Empurra para baixo para conectar com a bolinha
                
                // Bolinha externa
                Circle()
                    .fill(Color(hex: "D9D9D9"))
                    .frame(width: 35, height: 35)
                
                // Brilho/Bolinha interna
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .offset(x: 5, y: -5)
            }
            // Posição inicial (topo) e animação de puxar para baixo
            .offset(y: -25 + leverPull)
        }
    }
    
    // MARK: - Animações
    
    private func startSpinningAnimation() {
        guard !isSpinning else { return }
        isSpinning = true
        
        let itemHeight: CGFloat = 80
        // Ponto final de rolagem: total de palavras placeholders + 1 (a real)
        let totalItems = placeholderWords.count
        let finalOffset = -(CGFloat(totalItems) * itemHeight)
        
        // 1. Puxa a alavanca para baixo
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
            leverPull = 50 // Move a bolinha 50 pontos para baixo
        }
        
        // 2. Solta a alavanca e começa a rolar os nomes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                leverPull = 0 // Alavanca volta ao topo
            }
            
            // Se já tivermos a palavra, faz a roleta completa
            if viewModel.dailyWord != nil {
                withAnimation(.easeInOut(duration: 2.5)) {
                    wordsOffset = finalOffset
                }
                
                // Termina a animação
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    isSpinning = false
                }
            } else {
                // Simula um loading infinito enquanto a palavra não chega (rola algumas e reseta)
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    wordsOffset = -(CGFloat(placeholderWords.count - 1) * itemHeight)
                }
                
                // Tenta recarregar a palavra se falhou
                Task {
                    await viewModel.refreshWord()
                    // Para o spin infinito e ajusta pro final
                    withAnimation(.easeInOut(duration: 1.0)) {
                        wordsOffset = finalOffset
                    }
                    isSpinning = false
                }
            }
        }
    }
    
    // MARK: - Ações Auxiliares
    
    private func fetchUsername() {
        // Como o SupabaseAuth armazena apenas email/senha no objeto base User,
        // você teria que buscar o username na tabela profiles.
        // Por agora, pego a primeira parte do email se disponível.
        if let user = SupabaseService.shared.currentUser, let email = user.email {
            let namePart = email.components(separatedBy: "@").first ?? "Usuário"
            username = namePart
        }
    }
    
    // MARK: - Settings (Logout temporário para testar)
    private var settingsSheet: some View {
        NavigationView {
            List {
                Button(action: {
                    Task {
                        try? await SupabaseService.shared.signOut()
                        showSettings = false
                    }
                }) {
                    Text("Sair da Conta")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Configurações")
            .navigationBarItems(trailing: Button("Fechar") { showSettings = false })
        }
    }
}
