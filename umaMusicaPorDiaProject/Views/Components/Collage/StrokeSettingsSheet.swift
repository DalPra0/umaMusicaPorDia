import SwiftUI

struct StrokeSettingsSheet: View {
    @Binding var item: CollageItem
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ColorPicker("Cor do contorno", selection: strokeColorBinding, supportsOpacity: false)
                    .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Espessura")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary)
                            .frame(width: 24, height: 2)

                        Slider(value: $item.strokeWidth, in: 0...12, step: 0.5)

                        Circle()
                            .fill(Color(hex: item.strokeColorHex))
                            .frame(
                                width: max(8, item.strokeWidth * 2),
                                height: max(8, item.strokeWidth * 2)
                            )
                    }

                    Text("\(item.strokeWidth, specifier: "%.1f") px")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)

                Button("Remover contorno") {
                    item.strokeWidth = 0
                }
                .foregroundStyle(.red)

                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("Contorno")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }

    private var strokeColorBinding: Binding<Color> {
        Binding(
            get: { Color(hex: item.strokeColorHex) },
            set: { newColor in
                item.strokeColorHex = newColor.toHex() ?? item.strokeColorHex
                if item.strokeWidth == 0 {
                    item.strokeWidth = 2
                }
            }
        )
    }
}
