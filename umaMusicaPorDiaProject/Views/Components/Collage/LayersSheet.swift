import SwiftUI

struct LayersSheet: View {
    @Binding var items: [CollageItem]
    var onSaveState: () -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items.reversed()) { item in
                    HStack {
                        Image(uiImage: item.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        Text("Imagem")
                            .font(.subheadline)
                    }
                }
                .onMove { source, destination in
                    onSaveState()
                    var reversedItems = Array(items.reversed())
                    reversedItems.move(fromOffsets: source, toOffset: destination)
                    items = Array(reversedItems.reversed())
                }
                .onDelete { indexSet in
                    onSaveState()
                    var reversedItems = Array(items.reversed())
                    reversedItems.remove(atOffsets: indexSet)
                    items = Array(reversedItems.reversed())
                }
            }
            .navigationTitle("Camadas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                EditButton()
            }
        }
    }
}
