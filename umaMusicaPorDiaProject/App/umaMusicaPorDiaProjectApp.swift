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
                // Escutar mudanças no estado de autenticação
                for await state in SupabaseService.shared.client.auth.authStateChanges {
                    isAuthenticated = (state.session != nil)
                }
            }
        }
    }
}
