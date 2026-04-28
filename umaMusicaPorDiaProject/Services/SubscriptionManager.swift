import SwiftUI
import RevenueCat
import RevenueCatUI
import UIKit

@Observable
class SubscriptionManager: NSObject {
    static let shared = SubscriptionManager()
    private let premiumEntitlementID = "Bentô Pro"
    private var foregroundObserver: NSObjectProtocol?
    
    // Indica se o usuário tem o entitlement "Bentô Pro" ativo
    var isPremium: Bool = false
    
    // Armazena as ofertas disponíveis no Dashboard (Mensal, Trimestral, Anual)
    var offerings: Offerings? = nil
    var offeringsErrorMessage: String?
    
    // Estado para controlar a exibição do Customer Center
    var isShowingCustomerCenter: Bool = false
    
    override init() {
        super.init()
        Purchases.shared.delegate = self

        checkSubscriptionStatus()
        fetchOfferings()
        
        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.checkSubscriptionStatus()
        }
    }
    
    // Função que verifica se o usuário é Premium
    func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            self?.updatePremiumStatus(from: customerInfo)
        }
    }

    // Sincroniza o usuário do Supabase com o RevenueCat
    func sync(withUserID userID: UUID?) {
        if let userID = userID {
            let appUserID = userID.uuidString
            Purchases.shared.logIn(appUserID) { [weak self] (customerInfo, created, error) in
                if let error = error {
                    print("ERROR: Falha ao logar no RevenueCat: \(error.localizedDescription)")
                } else {
                    print("DEBUG: RevenueCat logado com ID: \(appUserID) (Novo: \(created))")
                    self?.updatePremiumStatus(from: customerInfo)
                }
            }
        } else {
            Purchases.shared.logOut { [weak self] (customerInfo, error) in
                if let error = error {
                    print("ERROR: Falha ao deslogar do RevenueCat: \(error.localizedDescription)")
                } else {
                    print("DEBUG: RevenueCat deslogado")
                    self?.updatePremiumStatus(from: customerInfo)
                }
            }
        }
    }
    
    // Busca os preços e pacotes (monthly, three_month, yearly)
    func fetchOfferings() {
        Purchases.shared.getOfferings { [weak self] (offerings, error) in
            DispatchQueue.main.async {
                self?.offerings = offerings
                self?.offeringsErrorMessage = error?.localizedDescription
            }
        }
    }

    @MainActor
    func preparePaywall() async -> Bool {
        await withCheckedContinuation { continuation in
            Purchases.shared.getOfferings { [weak self] (offerings, error) in
                DispatchQueue.main.async {
                    self?.offerings = offerings
                    self?.offeringsErrorMessage = error?.localizedDescription

                    let packages = offerings?.current?.availablePackages ?? []
                    continuation.resume(returning: !packages.isEmpty)
                }
            }
        }
    }
    
    // Função para restaurar compras antigas
    func restorePurchases() {
        Purchases.shared.restorePurchases { [weak self] (customerInfo, error) in
            self?.updatePremiumStatus(from: customerInfo)
        }
    }

    private func updatePremiumStatus(from customerInfo: CustomerInfo?) {
        let namedEntitlementActive = customerInfo?.entitlements[premiumEntitlementID]?.isActive ?? false
        let anyEntitlementActive = !(customerInfo?.entitlements.active.isEmpty ?? true)
        DispatchQueue.main.async {
            self.isPremium = namedEntitlementActive || anyEntitlementActive
        }
    }

    deinit {
        if let foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
        }
    }
}

extension SubscriptionManager: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        updatePremiumStatus(from: customerInfo)
    }
}
