import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var navigateToCollage = false
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "D9D9D9")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                    
                    Spacer()
                    
                    TimeMachineConsole(viewModel: viewModel)
                    
                    Spacer()
                    
                    actionButton
                }
            }
            .navigationDestination(isPresented: $navigateToCollage) {
                CollageCreatorView()
            }
            .sheet(isPresented: $showSettings) {
                SettingsSheet(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var header: some View {
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
    }
    
    private var actionButton: some View {
        AppButton(title: buttonTitle) {
            if !viewModel.isSpinning && viewModel.dailyWord != nil {
                navigateToCollage = true
            } else if !viewModel.isSpinning {
                viewModel.spin()
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
        .disabled(viewModel.isSpinning)
    }
    
    private var buttonTitle: String {
        if viewModel.isSpinning { return "Sorteando..." }
        return viewModel.dailyWord != nil ? "Continuar" : "Girar Máquina"
    }
}

// MARK: - Componentes Internos

struct TimeMachineConsole: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // Base da Máquina
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(hex: "1E1E1E"))
                .frame(width: 341, height: 444)
                .shadow(color: .black.opacity(0.2), radius: 15, y: 10)
            
            // Slot Visor
            WordSlotVisor(viewModel: viewModel)
            
            // Identificação do Usuário
            Text(viewModel.username)
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .tracking(0.4)
                .offset(y: 110)
            
            // Alavanca
            MachineLever(pullAmount: viewModel.leverPull)
                .offset(x: 130, y: 50)
        }
    }
}

struct WordSlotVisor: View {
    let viewModel: HomeViewModel
    private let itemHeight: CGFloat = 80
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 302, height: 220)
            
            VStack(spacing: 0) {
                // Placeholders
                ForEach(viewModel.placeholderWords, id: \.self) { word in
                    wordText(word)
                }
                
                // Real Word
                wordText(viewModel.dailyWord?.word.uppercased() ?? "...")
            }
            .offset(y: viewModel.wordsOffset)
            .frame(height: 220, alignment: .top)
            .clipped()
        }
        .offset(y: -70)
    }
    
    private func wordText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 34, weight: .bold))
            .foregroundColor(Color(hex: "1E1E1E"))
            .tracking(0.4)
            .frame(height: itemHeight)
    }
}

struct MachineLever: View {
    let pullAmount: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: "D9D9D9").opacity(0.3))
                .frame(width: 23, height: 96)
            
            ZStack {
                RoundedRectangle(cornerRadius: 19)
                    .fill(Color(hex: "6C6063"))
                    .frame(width: 8, height: 82)
                    .offset(y: 20)
                
                Circle()
                    .fill(Color(hex: "D9D9D9"))
                    .frame(width: 35, height: 35)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .offset(x: 5, y: -5)
            }
            .offset(y: -25 + pullAmount)
        }
    }
}

struct SettingsSheet: View {
    let viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Button(role: .destructive) {
                    Task {
                        await viewModel.signOut()
                        dismiss()
                    }
                } label: {
                    Label("Sair da Conta", systemImage: "door.left.hand.open")
                }
            }
            .navigationTitle("Configurações")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
}
