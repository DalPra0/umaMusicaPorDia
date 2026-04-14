import SwiftUI
import Supabase
import RevenueCat

@main
struct umaMusicaPorDiaProjectApp: App {
    @State private var isAuthenticated = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        // Inicialização do RevenueCat com a chave real
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "test_AdqgNewFdBqHYSTisdwQTGbYnjH")
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    if !hasCompletedOnboarding {
                        OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                    } else {
                        HomeView()
                            .transition(.opacity)
                    }
                } else {
                    AuthView()
                }
            }
            .environment(SubscriptionManager.shared) // Injeção do Gerenciador de Assinaturas
            .animation(.easeInOut, value: isAuthenticated)
            .animation(.easeInOut, value: hasCompletedOnboarding)
            .task {
                let authChanges = SupabaseService.shared.client.auth.authStateChanges
                for await state in authChanges {
                    withAnimation {
                        isAuthenticated = (state.session != nil)
                    }
                }
            }
        }
    }
}
