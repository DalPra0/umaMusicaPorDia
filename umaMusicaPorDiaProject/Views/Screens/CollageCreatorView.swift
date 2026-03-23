import SwiftUI
import PhotosUI

struct CollageItem: Identifiable {
    let id = UUID()
    var image: UIImage
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var rotation: Angle = .zero
    var lastRotation: Angle = .zero
}

struct CollageCreatorView: View {
    @StateObject private var viewModel = MusicViewModel()
    @State private var items: [CollageItem] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isSaving = false
    
    // Canvas para o Snapshot
    var canvas: some View {
        ZStack {
            Color.white // Fundo da colagem
            
            ForEach(items) { item in
                Image(uiImage: item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .rotationEffect(item.rotation)
                    .scaleEffect(item.scale)
                    .offset(item.offset)
            }
        }
        .frame(width: 400, height: 500) // Tamanho fixo para a colagem final
    }

    var body: some View {
        VStack {
            // 1. Cabeçalho com Palavra + Sorteio
            HStack {
                if let word = viewModel.dailyWord {
                    Text(word.word.uppercased())
                        .font(.system(size: 24, weight: .black, design: .serif))
                        .italic()
                        .foregroundColor(.purple)
                } else {
                    Text("SEM PALAVRA")
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    Task { await viewModel.refreshWord() }
                }) {
                    Image(systemName: "shuffle")
                        .font(.caption)
                        .padding(8)
                        .background(Color.purple.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.top)

            // 2. Área Interativa
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        Text(items.isEmpty ? "Adicione imagens nostálgicas..." : "")
                            .foregroundColor(.gray)
                    )
                
                // Canvas real onde o usuário mexe
                ForEach($items) { $item in
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .rotationEffect(item.rotation)
                        .scaleEffect(item.scale)
                        .offset(item.offset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    item.offset = CGSize(
                                        width: item.lastOffset.width + value.translation.width,
                                        height: item.lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { _ in item.lastOffset = item.offset }
                        )
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in item.scale = item.lastScale * value }
                                .onEnded { _ in item.lastScale = item.scale }
                                .simultaneously(with: RotationGesture()
                                    .onChanged { value in item.rotation = item.lastRotation + value }
                                    .onEnded { _ in item.lastRotation = item.rotation }
                                )
                        )
                }
            }
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding()

            // 3. Controles
            HStack(spacing: 20) {
                PhotosPicker(selection: $selectedItems, matching: .images) {
                    Label("IMG", systemImage: "photo.badge.plus")
                        .bold().padding().background(Color.blue.opacity(0.1)).cornerRadius(12)
                }
                
                Button(action: saveCollage) {
                    if isSaving {
                        ProgressView().padding()
                    } else {
                        Label("SALVAR", systemImage: "icloud.and.arrow.up.fill")
                            .bold().padding().background(items.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white).cornerRadius(12)
                    }
                }
                .disabled(items.isEmpty || isSaving)
            }
            .padding(.bottom)
        }
        .onAppear { viewModel.loadInitialData() }
        .onChange(of: selectedItems) { _, _ in loadSelectedImages() }
    }

    func loadSelectedImages() {
        for item in selectedItems {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run { items.append(CollageItem(image: uiImage)) }
                }
            }
        }
        selectedItems = []
    }

    @MainActor
    func saveCollage() {
        isSaving = true
        
        // --- NOVO SNAPSHOT REAL ---
        let renderer = ImageRenderer(content: canvas)
        renderer.scale = 3.0 // Alta qualidade para o banco
        
        if let uiImage = renderer.uiImage,
           let imageData = uiImage.jpegData(compressionQuality: 0.8) {
            
            let assets = items.map { item in
                CollageAsset(id: item.id.uuidString, x: Double(item.offset.width), y: Double(item.offset.height),
                             scale: Double(item.scale), rotation: item.rotation.degrees, type: "image")
            }
            
            Task {
                await viewModel.saveUserCollage(imageData: imageData, assets: assets)
                isSaving = false
                items = [] // Limpa após salvar
            }
        } else {
            isSaving = false
        }
    }
}
