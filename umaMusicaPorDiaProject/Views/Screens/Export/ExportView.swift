import SwiftUI
import Photos
import RevenueCatUI
import UIKit

struct ExportView: View {
    let renderedImage: UIImage
    @Environment(\.dismiss) private var dismiss
    @Environment(SubscriptionManager.self) private var subscriptionManager
    @State private var showSuccessMessage = false
    @State private var includeWatermark = true
    @State private var showPaywall = false
    
    private var exportImage: UIImage {
        includeWatermark ? renderedImage.applyingExportWatermark() : renderedImage
    }
    
    var body: some View {
        ZStack {
            Color(hex: "D9D9D9")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerToolbar
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                
                Spacer()
                
                previewArea
                
                Spacer()
                    .frame(height: 16)
                
                watermarkToggleCard
                
                Spacer()

                exportOptions
                    .padding(.bottom, 40)
            }
            
            if showSuccessMessage {
                successToast
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showPaywall, onDismiss: {
            subscriptionManager.checkSubscriptionStatus()
        }) {
            PaywallView(displayCloseButton: true)
        }
        .onAppear {
            includeWatermark = true
            subscriptionManager.checkSubscriptionStatus()
        }
    }
    
    private var headerToolbar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(hex: "6759F1"))
            }
            
            Spacer()
            
            Text("Exportar")
                .font(.system(size: 18, weight: .bold))
                .tracking(-0.31)
                .foregroundStyle(Color(hex: "6759F1"))
            
            Spacer()
            
            Image(systemName: "chevron.left").opacity(0)
        }
    }
    
    private var previewArea: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: renderedImage)
                .resizable()
                .scaledToFit()
                .frame(width: 281, height: 570)
            
            if includeWatermark {
                watermarkOverlay
                    .padding(.bottom, 18)
            }
        }
        .frame(width: 281, height: 570)
        .clipShape(RoundedRectangle(cornerRadius: 23))
    }
    
    private var watermarkOverlay: some View {
        VStack(spacing: 2) {
            Text("feito com")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.45), radius: 1, x: 0, y: 1)
            
            Image("LogoBentoVerde")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 40)
        }
    }
    
    private var watermarkToggleCard: some View {
        HStack(spacing: 12) {
            Text("Marca d’àgua")
                .font(.system(size: 18, weight: .bold))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .foregroundStyle(Color(hex: "6759F1"))
                .tracking(-0.23)
            
            Spacer()
            
            Toggle("", isOn: watermarkBinding)
                .labelsHidden()
                .tint(Color(hex: "FC02B2"))
        }
        .padding(.horizontal, 12)
        .frame(width: 281, height: 50)
        .background(Color(hex: "F2F2F2"))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var watermarkBinding: Binding<Bool> {
        Binding(
            get: { includeWatermark },
            set: { newValue in
                guard newValue != includeWatermark else { return }
                
                if !newValue && !subscriptionManager.isPremium {
                    includeWatermark = true
                    showPaywall = true
                    return
                }
                
                includeWatermark = newValue
            }
        )
    }
    
    private var exportOptions: some View {
        HStack(spacing: 58) {
            exportButton(systemIcon: "square.and.arrow.down", action: saveToPhotos)
            exportButton(assetName: "InstagramLogo", action: shareToInstagram)
            exportButton(assetName: "TikTokLogo", action: shareToTikTok)
        }
    }

    private func exportButton(assetName: String? = nil, systemIcon: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color(hex: "6759F1"))
                    .frame(width: 53, height: 53)

                if let assetName {
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                } else if let systemIcon {
                    Image(systemName: systemIcon)
                        .font(.system(size: 28))
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    private var successToast: some View {
        Text("Salvo na Galeria!")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { showSuccessMessage = false }
                }
            }
    }
    
    private func saveToPhotos() {
        let image = exportImage
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, _ in
                DispatchQueue.main.async {
                    if success { withAnimation { showSuccessMessage = true } }
                }
            })
        }
    }

    private func shareToInstagram() {
        UIPasteboard.general.image = exportImage
        let instagramURL = URL(string: "instagram://")!
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL)
        } else {
            share()
        }
    }

    private func shareToTikTok() {
        UIPasteboard.general.image = exportImage
        let tiktokURL = URL(string: "tiktok://")!
        if UIApplication.shared.canOpenURL(tiktokURL) {
            UIApplication.shared.open(tiktokURL)
        } else {
            share()
        }
    }

    private func share() {
        let activityVC = UIActivityViewController(activityItems: [exportImage], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

private extension UIImage {
    func applyingExportWatermark() -> UIImage {
        guard let logo = UIImage(named: "LogoBentoVerde"), size.width > 0, size.height > 0 else {
            return self
        }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
            
            let logoWidth = size.width * 0.28
            let logoHeight = logoWidth * (logo.size.height / max(logo.size.width, 1))
            let bottomPadding = size.height * 0.035
            let logoRect = CGRect(
                x: (size.width - logoWidth) / 2,
                y: size.height - logoHeight - bottomPadding,
                width: logoWidth,
                height: logoHeight
            )
            logo.draw(in: logoRect)
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black.withAlphaComponent(0.45)
            shadow.shadowOffset = CGSize(width: 0, height: 1)
            shadow.shadowBlurRadius = 1
            
            let fontSize = size.width * 0.04
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize, weight: .medium),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraph,
                .shadow: shadow
            ]
            
            let textHeight = fontSize * 1.4
            let textRect = CGRect(
                x: 0,
                y: logoRect.minY - textHeight + 2,
                width: size.width,
                height: textHeight
            )
            ("feito com" as NSString).draw(in: textRect, withAttributes: attributes)
        }
    }
}
