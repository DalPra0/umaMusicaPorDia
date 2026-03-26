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
                headerToolbar
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                
                Spacer()
                
                previewArea
                
                Spacer()
                
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                
                exportOptions
                    .padding(.bottom, 40)
            }
            
            if showSuccessMessage {
                successToast
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerToolbar: some View {
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
            
            Image(systemName: "chevron.left").opacity(0)
        }
    }
    
    private var previewArea: some View {
        Image(uiImage: renderedImage)
            .resizable()
            .scaledToFit()
            .frame(width: 302, height: 536)
            .cornerRadius(13)
            .shadow(color: .black.opacity(0.1), radius: 10)
    }
    
    private var exportOptions: some View {
        HStack(spacing: 40) {
            exportButton(icon: "square.and.arrow.down", action: saveToPhotos)
            exportButton(systemIcon: "camera.circle", action: { share(platform: "instagram") })
            exportButton(systemIcon: "music.note.list", action: { share(platform: "tiktok") })
        }
    }
    
    private func exportButton(icon: String? = nil, systemIcon: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color.white)
                    .frame(width: 53, height: 53)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(.black)
                } else if let systemIcon = systemIcon {
                    Image(systemName: systemIcon)
                        .font(.system(size: 28))
                        .foregroundColor(.black)
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
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            guard status == .authorized || status == .limited else { return }
            
            DispatchQueue.main.async {
                UIImageWriteToSavedPhotosAlbum(renderedImage, nil, nil, nil)
                withAnimation { showSuccessMessage = true }
            }
        }
    }
    
    private func share(platform: String) {
        let activityVC = UIActivityViewController(activityItems: [renderedImage], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
