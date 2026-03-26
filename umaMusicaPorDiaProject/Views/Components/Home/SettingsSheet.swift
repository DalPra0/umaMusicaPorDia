import SwiftUI

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
