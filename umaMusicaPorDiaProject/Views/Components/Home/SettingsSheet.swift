import SwiftUI
import RevenueCatUI

struct SettingsSheet: View {
    let viewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(SubscriptionManager.self) var subscriptionManager
    @AppStorage("haptics.level") private var hapticsLevelRawValue = HapticsManager.Level.medium.rawValue
    @State private var showPaywall = false
    @State private var showCustomerCenter = false
    @State private var showDeleteAccountConfirmation = false
    
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
                            Task {
                                let canOpenPaywall = await subscriptionManager.preparePaywall()
                                if canOpenPaywall {
                                    showPaywall = true
                                } else {
                                    viewModel.errorMessage = """
                                    Não foi possível carregar os planos agora.
                                    Verifique os produtos no App Store Connect e RevenueCat.
                                    Detalhe: \(subscriptionManager.offeringsErrorMessage ?? "sem detalhes")
                                    """
                                }
                            }
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
                            let didSignOut = await viewModel.signOut()
                            if didSignOut {
                                dismiss()
                            }
                        }
                    } label: {
                        Label("Sair da Conta", systemImage: "door.left.hand.open")
                    }

                    Button(role: .destructive) {
                        showDeleteAccountConfirmation = true
                    } label: {
                        Label("Excluir Conta", systemImage: "person.crop.circle.badge.xmark")
                    }
                    .disabled(viewModel.isDeletingAccount)
                }

                Section("Háptico") {
                    Picker("Intensidade", selection: $hapticsLevelRawValue) {
                        ForEach(HapticsManager.Level.allCases) { level in
                            Text(level.title).tag(level.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Sobre") {
                    Link(destination: URL(string: "https://uma-musica-por-dia.vercel.app/terms")!) {
                        Label("Termos de Uso (EULA)", systemImage: "doc.text")
                    }
                    Link(destination: URL(string: "https://uma-musica-por-dia.vercel.app/privacy")!) {
                        Label("Política de Privacidade", systemImage: "lock.shield")
                    }
                }
            }
            .navigationTitle("Configurações")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                }
            }
            .sheet(isPresented: $showPaywall, onDismiss: {
                subscriptionManager.checkSubscriptionStatus()
            }) {
                PaywallView(displayCloseButton: true)
            }
            .sheet(isPresented: $showCustomerCenter) {
                CustomerCenterView()
            }
            .alert("Erro", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .confirmationDialog(
                "Excluir conta?",
                isPresented: $showDeleteAccountConfirmation,
                titleVisibility: .visible
            ) {
                Button("Excluir permanentemente", role: .destructive) {
                    Task {
                        let didDelete = await viewModel.deleteAccount()
                        if didDelete {
                            dismiss()
                        }
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Essa ação remove sua conta e os dados associados de forma permanente.")
            }
            .onAppear {
                HapticsManager.shared.level = HapticsManager.Level(rawValue: hapticsLevelRawValue) ?? .medium
            }
            .onChange(of: hapticsLevelRawValue) { _, newValue in
                let level = HapticsManager.Level(rawValue: newValue) ?? .medium
                HapticsManager.shared.level = level
                HapticsManager.shared.playSelection()
            }
        }
    }
}
