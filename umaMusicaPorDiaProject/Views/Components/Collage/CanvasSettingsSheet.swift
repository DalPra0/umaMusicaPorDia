import SwiftUI
import RevenueCatUI

struct CanvasSettingsSheet: View {
    @Bindable var viewModel: CollageViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(SubscriptionManager.self) var subscriptionManager
    @State private var showPaywall = false
    
    private let colors: [Color] = [.white, Color(hex: "F0F0F0"), .black, Color(hex: "D9D9D9")]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Configurações do Canvas")
                .font(.headline)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Proporção")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 20) {
                    ForEach(CollageViewModel.CanvasRatio.allCases, id: \.self) { ratio in
                        let isLocked = ratio != .story && !subscriptionManager.isPremium
                        
                        Button(action: {
                            if isLocked {
                                showPaywall = true
                            } else {
                                withAnimation(.spring()) {
                                    viewModel.setCanvasRatio(ratio)
                                }
                            }
                        }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(viewModel.canvasRatio == ratio ? Color.black : Color.gray.opacity(0.3), lineWidth: 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(viewModel.canvasRatio == ratio ? Color.black.opacity(0.05) : Color.clear)
                                        )
                                        .frame(width: 60, height: 60 / (ratio == .story ? 9.0/16.0 : (ratio == .portrait ? 4.0/5.0 : 1.0)) * 0.5)
                                        .aspectRatio(ratio.ratio, contentMode: .fit)
                                        .frame(width: 60, height: 80)
                                        .overlay(
                                            ZStack {
                                                if isLocked {
                                                    Color.white.opacity(0.6)
                                                        .cornerRadius(8)
                                                    Image(systemName: "lock.fill")
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        )
                                    
                                    if viewModel.canvasRatio == ratio {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.black)
                                            .offset(x: 25, y: -35)
                                    }
                                }
                                
                                Text(ratio.rawValue)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(viewModel.canvasRatio == ratio ? .black : (isLocked ? .gray.opacity(0.5) : .gray))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                // ... (rest of background color code remains same)
                Text("Cor de Fundo")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    ForEach(colors, id: \.self) { color in
                        Button(action: { viewModel.setCanvasColor(color) }) {
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .foregroundColor(color == .white || color == Color(hex: "F0F0F0") || color == Color(hex: "D9D9D9") ? .black : .white)
                                        .opacity(viewModel.canvasColor == color ? 1 : 0)
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            AppButton(title: "FECHAR") {
                dismiss()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .presentationDetents([.medium])
        .sheet(isPresented: $showPaywall, onDismiss: {
            subscriptionManager.checkSubscriptionStatus()
        }) {
            PaywallView(displayCloseButton: true)
        }
    }
}
