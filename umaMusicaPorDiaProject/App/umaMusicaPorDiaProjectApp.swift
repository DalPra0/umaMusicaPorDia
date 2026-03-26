import SwiftUI
import Supabase

@main
struct umaMusicaPorDiaProjectApp: App {
    @State private var isAuthenticated = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    HomeView()
                } else {
                    AuthView()
                }
            }
            .task {
                // Escuta mudanças de estado de autenticação globalmente
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
