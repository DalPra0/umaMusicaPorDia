import SwiftUI

struct BasketColorSettingsSheet: View {
    @Binding var selectedColor: Color
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Escolha uma cor")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                    ForEach(BasketConfiguration.swatchHexes, id: \.self) { hex in
                        let swatchColor = Color(hex: hex)
                        Button {
                            selectedColor = swatchColor
                        } label: {
                            Circle()
                                .fill(swatchColor)
                                .frame(width: 32, height: 32)
                                .overlay {
                                    Circle()
                                        .stroke(
                                            selectedColor.toHex() == hex ? Color.primary : Color.primary.opacity(0.25),
                                            lineWidth: selectedColor.toHex() == hex ? 2 : 1
                                        )
                                }
                        }
                    }
                }

                ColorPicker("Mais cores", selection: $selectedColor, supportsOpacity: false)

                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedColor)
                    .frame(height: 44)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                    }
                    .accessibilityLabel("Pré-visualização da cor selecionada")

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
