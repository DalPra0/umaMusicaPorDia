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
                    headerToolbar
                    
                    Spacer()
                    
                    TimeMachineConsole(viewModel: viewModel)
                    
                    Spacer()
                    
                    actionButton
                }
            }
            .navigationDestination(isPresented: $navigateToCollage) {
                if let word = viewModel.dailyWord?.word {
                    BasketSelectionView(dailyWord: word)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsSheet(viewModel: viewModel)
            }
        }
    }
    
    private var headerToolbar: some View {
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
