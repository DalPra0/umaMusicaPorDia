import SwiftUI
import PhotosUI

struct CollageTestView: View {
    @StateObject private var viewModel = MusicViewModel()
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isUploading = false
    @State private var uploadStatus: String?
    
    var body: some View {
        VStack(spacing: 30) {
            // 1. Palavra do Dia
            VStack {
                Text("PALAVRA DO DIA")
                    .font(.caption).tracking(2).foregroundColor(.secondary)
                if let word = viewModel.dailyWord {
                    Text(word.word)
                        .font(.system(size: 40, weight: .black, design: .serif))
                        .foregroundColor(.purple)
                } else if viewModel.isLoadingWord {
                    ProgressView()
                } else {
                    Text("Nenhuma palavra hoje").foregroundColor(.red)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(20)
            
            // 2. Simulador de Colagem (Seleção de Imagem)
            VStack(spacing: 15) {
                Text("Selecione uma imagem para simular sua colagem:")
                    .font(.subheadline)
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let data = selectedImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .clipped()
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.largeTitle)
                        }
                    }
                }
            }
            
            // 3. Botão de Enviar
            if let data = selectedImageData, !isUploading {
                Button(action: {
                    uploadCollage(data: data)
                }) {
                    HStack {
                        Image(systemName: "cloud.fill")
                        Text("Enviar Colagem para o Supabase")
                    }
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else if isUploading {
                ProgressView("Subindo imagem e dados...")
            }
            
            if let status = uploadStatus {
                Text(status)
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Teste de Banco")
        .onAppear { viewModel.loadInitialData() }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                }
            }
        }
    }
    
    func uploadCollage(data: Data) {
        isUploading = true
        Task {
            // Criando um asset fake para o teste
            let fakeAsset = CollageAsset(id: "test-img-1", x: 100, y: 100, scale: 1.0, rotation: 0, type: "image")
            
            await viewModel.saveUserCollage(imageData: data, assets: [fakeAsset])
            
            DispatchQueue.main.async {
                isUploading = false
                uploadStatus = "Sucesso! Verifique seu dashboard do Supabase."
            }
        }
    }
}
