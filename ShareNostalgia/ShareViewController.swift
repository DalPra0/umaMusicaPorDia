import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers
import Supabase

class ShareViewController: UIViewController {
    
    let supabase = SharedSupabaseClient.shared.client

    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let cardView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDebugUI()
        processShareItems()
    }

    private func setupDebugUI() {
        view.backgroundColor = .systemGroupedBackground

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 24
        cardView.layer.masksToBounds = true
        view.addSubview(cardView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Importando recorte"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 15, weight: .medium)
        statusLabel.textColor = .secondaryLabel
        statusLabel.text = "Preparando importação..."

        let iconView = UIImageView(image: UIImage(systemName: "square.and.arrow.down.on.square.fill"))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .systemBlue
        iconView.contentMode = .scaleAspectFit

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        let contentStack = UIStackView(arrangedSubviews: [iconView, titleLabel, statusLabel, activityIndicator])
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 14
        contentStack.alignment = .center

        cardView.contentView.addSubview(contentStack)

        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Cancelar", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        closeButton.setTitleColor(.systemBlue, for: .normal)
        closeButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            cardView.widthAnchor.constraint(equalToConstant: 320),
            cardView.heightAnchor.constraint(equalToConstant: 260),

            contentStack.leadingAnchor.constraint(equalTo: cardView.contentView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: cardView.contentView.trailingAnchor, constant: -20),
            contentStack.centerYAnchor.constraint(equalTo: cardView.contentView.centerYAnchor),

            iconView.widthAnchor.constraint(equalToConstant: 56),
            iconView.heightAnchor.constraint(equalToConstant: 56),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    @objc private func cancelTapped() {
        finish(error: "Cancelado pelo usuário")
    }

    private func updateStatus(_ message: String) {
        DispatchQueue.main.async {
            print("DEBUG SHARE: \(message)")
            self.statusLabel.text = message
        }
    }

    private func processShareItems() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else {
            finish(error: "Nenhum anexo encontrado")
            return
        }
        
        updateStatus("Processando \(attachments.count) anexos...")
        print("DEBUG SHARE: Total de \(attachments.count) attachments recebidos")
        
        Task {
            var processedCount = 0
            for (index, attachment) in attachments.enumerated() {
                print("DEBUG SHARE: Attachment #\(index) - Verificando tipos...")
                print("DEBUG SHARE: Tem imagem? \(attachment.hasItemConformingToTypeIdentifier(UTType.image.identifier))")
                print("DEBUG SHARE: Tem URL? \(attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier))")
                print("DEBUG SHARE: Tem texto? \(attachment.hasItemConformingToTypeIdentifier(UTType.text.identifier))")
                print("DEBUG SHARE: Tem data? \(attachment.hasItemConformingToTypeIdentifier(UTType.data.identifier))")
                
                if attachment.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    updateStatus("Lendo imagem direta...")
                    await handleImage(attachment)
                    processedCount += 1
                } else if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    updateStatus("Lendo link...")
                    await handleURL(attachment)
                    processedCount += 1
                } else if attachment.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                    updateStatus("Tentando extrair URL do texto...")
                    await handleText(attachment)
                    processedCount += 1
                }
            }
            
            if processedCount == 0 {
                finish(error: "Nenhuma imagem ou link válido encontrado nos anexos")
            } else {
                updateStatus("Concluído com sucesso!")
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                finish()
            }
        }
    }

    private func handleImage(_ attachment: NSItemProvider) async {
        do {
            let provider = try await attachment.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil)
            var imageData: Data?
            
            if let url = provider as? URL {
                imageData = try Data(contentsOf: url)
            } else if let image = provider as? UIImage {
                imageData = image.jpegData(compressionQuality: 0.8)
            }
            
            if let data = imageData {
                await uploadToSupabase(data: data)
            }
        } catch {
            updateStatus("Erro ao ler imagem: \(error.localizedDescription)")
        }
    }

    private func handleURL(_ attachment: NSItemProvider) async {
        do {
            let provider = try await attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil)
            if let url = provider as? URL {
                updateStatus("Baixando do link: \(url.lastPathComponent)")
                print("DEBUG SHARE: URL recebida: \(url.absoluteString)")
                
                let (data, response) = try await URLSession.shared.data(from: url)
                
                if let mimeType = response.mimeType, mimeType.contains("image") {
                    print("DEBUG SHARE: URL é imagem direta, fazendo upload")
                    await uploadToSupabase(data: data)
                } else if let mimeType = response.mimeType, mimeType.contains("html") {
                    print("DEBUG SHARE: URL é página HTML (Pinterest), tentando extrair imagem...")
                    updateStatus("Extraindo imagem da página...")
                    
                    if let imageUrl = await extractImageFromPinterestHTML(data: data, originalUrl: url) {
                        print("DEBUG SHARE: Imagem encontrada: \(imageUrl)")
                        updateStatus("Baixando imagem...")
                        let (imageData, _) = try await URLSession.shared.data(from: imageUrl)
                        await uploadToSupabase(data: imageData)
                    } else {
                        updateStatus("Não consegui encontrar a imagem neste pin")
                        print("DEBUG SHARE: Falha ao extrair imagem do HTML")
                    }
                } else {
                    print("DEBUG SHARE: URL não é imagem nem HTML. MIME: \(response.mimeType ?? "unknown")")
                    updateStatus("Tipo de conteúdo não suportado")
                }
            }
        } catch {
            updateStatus("Erro ao baixar link: \(error.localizedDescription)")
            print("DEBUG SHARE: Erro em handleURL: \(error)")
        }
    }
    
    private func extractImageFromPinterestHTML(data: Data, originalUrl: URL) async -> URL? {
        guard let html = String(data: data, encoding: .utf8) else {
            print("DEBUG SHARE: Não conseguiu converter HTML para string")
            return nil
        }
        
        
        if let ogImageRange = html.range(of: #"<meta property="og:image" content="([^"]+)"#, options: .regularExpression) {
            let match = html[ogImageRange]
            if let urlRange = match.range(of: #"content="([^"]+)"#, options: .regularExpression) {
                let urlString = match[urlRange]
                    .replacingOccurrences(of: "content=\"", with: "")
                    .replacingOccurrences(of: "\"", with: "")
                if let url = URL(string: urlString) {
                    print("DEBUG SHARE: Encontrou imagem via og:image: \(urlString)")
                    return url
                }
            }
        }
        
        let pattern = #"https://i\.pinimg\.com/[^"'\s>]+"#
        if let range = html.range(of: pattern, options: .regularExpression) {
            let urlString = String(html[range])
            if let url = URL(string: urlString) {
                print("DEBUG SHARE: Encontrou imagem via i.pinimg.com: \(urlString)")
                return url
            }
        }
        
        if let srcRange = html.range(of: #"src="(https://i\.pinimg\.com/[^"]+)"#, options: .regularExpression) {
            let match = html[srcRange]
            if let urlRange = match.range(of: #"https://i\.pinimg\.com/[^"]+"#, options: .regularExpression) {
                let urlString = String(match[urlRange])
                if let url = URL(string: urlString) {
                    print("DEBUG SHARE: Encontrou imagem via src: \(urlString)")
                    return url
                }
            }
        }
        
        print("DEBUG SHARE: Não encontrou nenhuma imagem nos padrões conhecidos")
        print("DEBUG SHARE: HTML preview (primeiros 500 chars): \(html.prefix(500))")
        return nil
    }
    
    private func handleText(_ attachment: NSItemProvider) async {
        do {
            let provider = try await attachment.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil)
            if let text = provider as? String {
                print("DEBUG SHARE: Texto recebido: \(text)")
                if let url = URL(string: text), url.scheme != nil {
                    print("DEBUG SHARE: Encontrou URL no texto: \(url.absoluteString)")
                    let attachment = NSItemProvider(item: url as NSURL, typeIdentifier: UTType.url.identifier)
                    await handleURL(attachment)
                }
            }
        } catch {
            print("DEBUG SHARE: Erro em handleText: \(error)")
        }
    }

    private func uploadToSupabase(data: Data) async {
        do {
            updateStatus("Verificando autenticação...")
            
            let session = try await supabase.auth.session
            let userId = session.user.id
            let accessToken = session.accessToken
            
            updateStatus("Autenticado como: \(userId.uuidString.prefix(8))...")
            print("DEBUG SHARE: Access Token existe: \(accessToken.isEmpty ? "NÃO" : "SIM") - Length: \(accessToken.count)")
            print("DEBUG SHARE: User ID: \(userId.uuidString)")

            let fileName = "\(userId.uuidString)/\(UUID().uuidString).jpg"
            print("DEBUG SHARE: Tentando upload para: \(fileName)")

            
            updateStatus("Subindo para o Storage...")
            try await supabase.storage
                .from("user_assets")
                .upload(fileName, data: data, options: FileOptions(contentType: "image/jpeg"))
            
            let imageUrl = try supabase.storage
                .from("user_assets")
                .getPublicURL(path: fileName)
                .absoluteString
            
            updateStatus("Salvando no Banco de Dados...")
            let assetData: [String: AnyJSON] = [
                "user_id": .string(userId.uuidString),
                "image_url": .string(imageUrl)
            ]
            
            try await supabase
                .from("user_assets")
                .insert(assetData)
                .execute()
            
            updateStatus("Recorte salvo com sucesso!")
        } catch {
            updateStatus("Falha no upload: \(error.localizedDescription)")
            print("DEBUG SHARE ERROR DETAIL: \(error)")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
    }

    private func finish(error: String? = nil) {
        if let error = error {
            print("DEBUG SHARE ERROR: \(error)")
        }
        DispatchQueue.main.async {
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
}

extension NSItemProvider {
    func loadItem(forTypeIdentifier identifier: String, options: [AnyHashable : Any]? = nil) async throws -> NSSecureCoding {
        try await withCheckedThrowingContinuation { continuation in
            self.loadItem(forTypeIdentifier: identifier, options: options) { (item, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let item = item {
                    continuation.resume(returning: item)
                }
            }
        }
    }
}
