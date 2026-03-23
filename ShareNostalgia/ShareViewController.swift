import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers
import Supabase

class ShareViewController: SLComposeServiceViewController {
    
    // Configuração local rápida (Idealmente compartilhada via Target Membership)
    let supabase = SupabaseClient(
        supabaseURL: URL(string: "https://nyqetgzzvcitftejsrue.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im55cWV0Z3p6dmNpdGZ0ZWpzcnVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4NjM1ODYsImV4cCI6MjA4OTQzOTU4Nn0.Cug2NDaRwy-Ldv1tdMuNlU8a9Vph1D_9wAT1qB9-vwg"
    )

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachment = item.attachments?.first else {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        // Identificador para imagens
        let imageType = UTType.image.identifier
        
        if attachment.hasItemConformingToTypeIdentifier(imageType) {
            attachment.loadItem(forTypeIdentifier: imageType, options: nil) { (item, error) in
                Task {
                    do {
                        var imageData: Data?
                        
                        if let url = item as? URL {
                            imageData = try Data(contentsOf: url)
                        } else if let image = item as? UIImage {
                            imageData = image.jpegData(compressionQuality: 0.8)
                        }
                        
                        guard let data = imageData else { return }
                        
                        // 1. Login (Para testes, usamos anônimo se não houver sessão compartilhada)
                        let session = try await self.supabase.auth.session
                        let userId = session.user.id
                        
                        // 2. Upload para o bucket 'user_assets'
                        let fileName = "\(userId.uuidString)/\(UUID().uuidString).jpg"
                        try await self.supabase.storage
                            .from("user_assets")
                            .upload(fileName, data: data, options: FileOptions(contentType: "image/jpeg"))
                        
                        // 3. Pegar URL Pública
                        let imageUrl = try self.supabase.storage
                            .from("user_assets")
                            .getPublicURL(path: fileName)
                            .absoluteString
                        
                        // 4. Salvar na tabela user_assets
                        let assetData: [String: AnyJSON] = [
                            "user_id": .string(userId.uuidString),
                            "image_url": .string(imageUrl)
                        ]
                        
                        try await self.supabase
                            .from("user_assets")
                            .insert(assetData)
                            .execute()
                        
                        print("DEBUG: Upload do Share Extension concluído!")
                        
                    } catch {
                        print("DEBUG: Erro no Share Extension: \(error)")
                    }
                    
                    await MainActor.run {
                        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
            }
        } else {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        return []
    }
}
