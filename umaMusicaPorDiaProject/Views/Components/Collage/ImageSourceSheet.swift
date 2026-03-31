import SwiftUI

struct ImageSourceSheet: View {
    @Environment(\.dismiss) var dismiss
    var onSelectPhotos: () -> Void
    var onSelectPinterest: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2.5)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 36, height: 5)
                .padding(.top, 6)
            
            HStack {
                Text("Images")
                    .font(.system(size: 20, weight: .semibold))
                    .tracking(-0.45)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 30)
            
            HStack(spacing: 60) {
                VStack(spacing: 8) {
                    Button(action: {
                        dismiss()
                        onSelectPhotos()
                    }) {
                        sourceIconBackground {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                        }
                    }
                    Text("Photos")
                        .font(.system(size: 13, weight: .medium))
                }
                
                VStack(spacing: 8) {
                    Button(action: {
                        dismiss()
                        onSelectPinterest()
                    }) {
                        sourceIconBackground {
                            Image(systemName: "p.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                        }
                    }
                    Text("Pinterest")
                        .font(.system(size: 13, weight: .medium))
                }
            }
            .padding(.bottom, 40)
            
            Spacer()
        }
        .presentationDetents([.height(250)])
        .presentationDragIndicator(.hidden)
    }
    
    private func sourceIconBackground<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(hex: "ABABAB"))
                .frame(width: 86, height: 86)
            
            content()
        }
    }
}
