import SwiftUI
import Supabase
import RevenueCat
import UIKit
import UserNotifications

@main
struct umaMusicaPorDiaProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var isAuthenticated = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_OfnfOEKIAxccbYUvTTnspTWHFbQ")
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
            .preferredColorScheme(.light)
            .animation(.easeInOut, value: isAuthenticated)
            .animation(.easeInOut, value: hasCompletedOnboarding)
            .task {
                let authChanges = SupabaseService.shared.client.auth.authStateChanges
                for await state in authChanges {
                    withAnimation {
                        isAuthenticated = (state.session != nil)
                    }
                    
                    // Sincroniza o RevenueCat com o ID do usuário do Supabase
                    SubscriptionManager.shared.sync(withUserID: state.session?.user.id)

                    do {
                        try await NotificationManager.shared.syncDailyRemindersWithCurrentState()
                    } catch {
                        print("ERROR: Falha ao sincronizar notificações: \(error.localizedDescription)")
                    }
                }
            }
            .task {
                for await _ in NotificationCenter.default.notifications(named: UIApplication.willEnterForegroundNotification) {
                    do {
                        try await NotificationManager.shared.syncDailyRemindersWithCurrentState()
                    } catch {
                        print("ERROR: Falha ao atualizar notificações no foreground: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        Task { @MainActor in
            HapticsManager.shared.playNotificationReceived()
        }
        completionHandler([.banner, .sound, .badge])
    }
}
