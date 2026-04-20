import SwiftUI

struct BasketVariantSettingsSheet: View {
    let options: [BasketVariantOption]
    @Binding var selectedVariantAssetName: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Escolha a variação")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(options) { option in
                        let isSelected = selectedVariantAssetName == option.assetName
                        Button {
                            selectedVariantAssetName = option.assetName
                        } label: {
                            VStack(spacing: 8) {
                                if let swatchHex = option.swatchHex {
                                    Circle()
                                        .fill(Color(hex: swatchHex))
                                        .frame(width: 28, height: 28)
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 28, height: 28)
                                }

                                Text(option.title)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isSelected ? Color.primary.opacity(0.12) : Color(.secondarySystemBackground))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isSelected ? Color.primary : Color.primary.opacity(0.15), lineWidth: 1)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationTitle("Cor da Cesta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
}
