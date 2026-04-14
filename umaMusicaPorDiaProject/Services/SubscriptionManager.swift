import SwiftUI
import RevenueCat
import RevenueCatUI

@Observable
class SubscriptionManager {
    static let shared = SubscriptionManager()
    
    // Indica se o usuário tem o entitlement "Bentô Pro" ativo
    var isPremium: Bool = false
    
    // Armazena as ofertas disponíveis no Dashboard (Mensal, Trimestral, Anual)
    var offerings: Offerings? = nil
    
    // Estado para controlar a exibição do Customer Center
    var isShowingCustomerCenter: Bool = false
    
    init() {
        // Verifica o status logo ao iniciar
        checkSubscriptionStatus()
        fetchOfferings()
    }
    
    // Função que verifica se o usuário é Premium
    func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { [weak self] (customerInfo, error) in
            // Mudamos para "Bentô Pro" conforme solicitado
            self?.isPremium = customerInfo?.entitlements["Bentô Pro"]?.isActive ?? false
        }
    }
    
    // Busca os preços e pacotes (monthly, three_month, yearly)
    func fetchOfferings() {
        Purchases.shared.getOfferings { [weak self] (offerings, error) in
            self?.offerings = offerings
        }
    }
    
    // Função para restaurar compras antigas
    func restorePurchases() {
        Purchases.shared.restorePurchases { [weak self] (customerInfo, error) in
            self?.isPremium = customerInfo?.entitlements["Bentô Pro"]?.isActive ?? false
        }
    }
}
