import SwiftUI

struct PinterestAssetsSheet: View {
    @Environment(\.dismiss) var dismiss
    var viewModel: CollageViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Grabber
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 6)
            
            // Header
            HStack {
                Text("Saved from Pinterest")
                    .font(.system(size: 20, weight: .semibold))
                    .tracking(-0.45)
                
                Spacer()
                
                // Botão de refresh
                Button(action: {
                    Task {
                        await viewModel.fetchUserAssets()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 20))
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 12)
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 20)
            
            // Grid
            ScrollView {
                if viewModel.isLoadingAssets {
                    ProgressView()
                        .padding(.top, 50)
                } else if viewModel.userAssets.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "tray.2")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Nenhum recorte encontrado.\nUse o Share do Pinterest para importar!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 50)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.userAssets) { asset in
                            AsyncImage(url: URL(string: asset.imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .aspectRatio(1, contentMode: .fill)
                                        .overlay(ProgressView())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .aspectRatio(1, contentMode: .fill)
                                        .cornerRadius(12)
                                        .clipped()
                                        .onTapGesture {
                                            viewModel.addRemoteAsset(asset.imageUrl)
                                            dismiss()
                                        }
                                case .failure(let error):
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.red.opacity(0.2))
                                        .aspectRatio(1, contentMode: .fill)
                                        .overlay(
                                            VStack {
                                                Image(systemName: "exclamationmark.triangle")
                                                    .foregroundColor(.red)
                                                Text("Erro")
                                                    .font(.caption)
                                                    .foregroundColor(.red)
                                            }
                                        )
                                        .onAppear {
                                            print("DEBUG: Erro ao carregar \(asset.imageUrl): \(error)")
                                        }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .id(asset.id) // Importante para evitar recargas
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            Spacer()
        }
        .task(id: viewModel.userAssets.count) {
            // Busca sempre que o sheet aparece ou quando a contagem muda
            await viewModel.fetchUserAssets()
        }
    }
}
