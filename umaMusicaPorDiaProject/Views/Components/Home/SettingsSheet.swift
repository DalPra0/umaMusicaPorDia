import SwiftUI
import RevenueCatUI

struct SettingsSheet: View {
    let viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(SubscriptionManager.self) var subscriptionManager
    @State private var showPaywall = false
    @State private var showCustomerCenter = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Assinatura") {
                    if subscriptionManager.isPremium {
                        Button {
                            showCustomerCenter = true
                        } label: {
                            Label("Gerenciar Assinatura", systemImage: "creditcard.fill")
                        }
                        .foregroundColor(.blue)
                    } else {
                        Button {
                            showPaywall = true
                        } label: {
                            HStack {
                                Label("Seja Premium", systemImage: "star.fill")
                                Spacer()
                                Text("PRO")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(6)
                            }
                        }
                        .foregroundColor(.primary)
                    }
                    
                    Button {
                        subscriptionManager.restorePurchases()
                    } label: {
                        Label("Restaurar Compras", systemImage: "arrow.clockwise")
                    }
                }
                
                Section("Conta") {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.signOut()
                            dismiss()
                        }
                    } label: {
                        Label("Sair da Conta", systemImage: "door.left.hand.open")
                    }
                }
            }
            .navigationTitle("Configurações")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(displayCloseButton: true)
            }
            .sheet(isPresented: $showCustomerCenter) {
                CustomerCenterView()
            }
        }
    }
}
