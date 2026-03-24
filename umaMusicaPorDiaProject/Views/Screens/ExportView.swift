import SwiftUI
import Photos

struct ExportView: View {
    let renderedImage: UIImage
    @Environment(\.dismiss) var dismiss
    @State private var showSuccessMessage = false
    
    var body: some View {
        ZStack {
            Color(hex: "D9D9D9")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Header
                header
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                
                Spacer()
                
                // 2. Preview da Colagem
                Image(uiImage: renderedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 302, height: 536)
                    .cornerRadius(13)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                
                Spacer()
                
                // 3. Divider
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                
                // 4. Botões de Exportação
                exportButtons
                    .padding(.bottom, 40)
            }
            
            // Toast de Sucesso
            if showSuccessMessage {
                VStack {
                    Text("Salvo na Galeria!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Exportar")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "4A4242"))
            
            Spacer()
            
            // Placeholder para manter o título centralizado
            Image(systemName: "chevron.left")
                .opacity(0)
        }
    }
    
    private var exportButtons: some View {
        HStack(spacing: 40) {
            // Botão Salvar
            Button(action: saveToPhotos) {
                exportButtonContent(iconName: "square.and.arrow.down")
            }
            
            // Botão Instagram
            Button(action: { shareToSocial(platform: "instagram") }) {
                exportButtonContent(imageName: "instagram_icon") // Assumindo que você terá esses assets ou usaremos placeholders
                    .overlay(
                        // Fallback caso não tenha a imagem: círculo estilo Instagram
                        Image(systemName: "camera.circle")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    )
            }
            
            // Botão TikTok
            Button(action: { shareToSocial(platform: "tiktok") }) {
                exportButtonContent(imageName: "tiktok_icon")
                    .overlay(
                        Image(systemName: "music.note.list")
                            .font(.system(size: 26))
                            .foregroundColor(.black)
                    )
            }
        }
    }
    
    private func exportButtonContent(iconName: String? = nil, imageName: String? = nil) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.white)
                .frame(width: 53, height: 53)
            
            if let icon = iconName {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }
        }
    }
    
    // MARK: - Ações
    
    private func saveToPhotos() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    UIImageWriteToSavedPhotosAlbum(renderedImage, nil, nil, nil)
                    withAnimation {
                        showSuccessMessage = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { showSuccessMessage = false }
                    }
                case .denied, .restricted:
                    // Aqui você poderia mostrar um alerta pedindo pro usuário ir nas Configurações
                    print("Acesso à Galeria negado.")
                default:
                    break
                }
            }
        }
    }
    
    private func shareToSocial(platform: String) {
        // Aqui abriria a ShareSheet nativa focada na plataforma ou usando SDKs
        let activityVC = UIActivityViewController(activityItems: [renderedImage], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
