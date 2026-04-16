import SwiftUI
import RevenueCat
import RevenueCatUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var navigateToCollage = false
    @State private var showSettings = false
    @Environment(SubscriptionManager.self) private var subscriptionManager
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // 1. Fundo Gradiente exato do Figma
                LinearGradient(
                    colors: [Color(hex: "81E862"), Color(hex: "6759F1")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // 2. Máquina Gacha (Começando do topo absoluto)
                TimeMachineConsole(viewModel: viewModel)
                    .ignoresSafeArea()
                
                // 3. Botão Girar e Barra Superior flutuando por cima
                VStack {
                    headerToolbar
                    
                    Spacer()
                    
                    actionButton
                        .padding(.bottom, 40)
                }
            }
            .navigationDestination(isPresented: $navigateToCollage) {
                if let dailyWord = viewModel.dailyWord {
                    BasketSelectionView(dailyWord: dailyWord)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsSheet(viewModel: viewModel)
            }
            .onAppear {
                subscriptionManager.checkSubscriptionStatus()
            }
            .alert("Erro", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
    
    private var headerToolbar: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "6759F1"))
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            Spacer()
        }
    }
    
    private var actionButton: some View {
        Button(action: {
            if !viewModel.isSpinning && viewModel.dailyWord != nil {
                navigateToCollage = true
            } else if !viewModel.isSpinning {
                viewModel.spin()
            }
        }) {
            Text(buttonTitle)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(Color(hex: "FC02B2"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 24)
        .disabled(viewModel.isSpinning)
    }
    
    private var buttonTitle: String {
        if viewModel.isSpinning { return "Sorteando..." }
        return viewModel.dailyWord != nil ? "Continuar" : "Girar"
    }
}
