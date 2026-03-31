import SwiftUI
import Supabase

@main
struct umaMusicaPorDiaProjectApp: App {
    @State private var isAuthenticated = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
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
