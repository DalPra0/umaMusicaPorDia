import SwiftUI

// Forma orgânica/blob irregular para o sticker - imita a forma do Figma
struct BlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        // Forma orgânica irregular que acompanha o texto
        path.move(to: CGPoint(x: width * 0.15, y: height * 0.05))
        
        // Topo com curvas irregulares
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: 0),
            control: CGPoint(x: width * 0.3, y: -height * 0.02)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.85, y: height * 0.08),
            control: CGPoint(x: width * 0.7, y: -height * 0.03)
        )
        
        // Lado direito com ondulações
        path.addQuadCurve(
            to: CGPoint(x: width * 0.98, y: height * 0.35),
            control: CGPoint(x: width * 1.05, y: height * 0.15)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.95, y: height * 0.65),
            control: CGPoint(x: width * 1.02, y: height * 0.5)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.88, y: height * 0.92),
            control: CGPoint(x: width * 0.98, y: height * 0.8)
        )
        
        // Base com curvas irregulares
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.98),
            control: CGPoint(x: width * 0.7, y: height * 1.05)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.12, y: height * 0.9),
            control: CGPoint(x: width * 0.3, y: height * 1.03)
        )
        
        // Lado esquerdo com ondulações
        path.addQuadCurve(
            to: CGPoint(x: 0, y: height * 0.6),
            control: CGPoint(x: -width * 0.05, y: height * 0.75)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.05, y: height * 0.3),
            control: CGPoint(x: -width * 0.02, y: height * 0.45)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.15, y: height * 0.05),
            control: CGPoint(x: 0, y: height * 0.15)
        )
        
        path.closeSubpath()
        return path
    }
}

struct NeonSticker: View {
    let text: String
    let neonColor: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.yellow)
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                BlobShape()
                    .fill(.black)
            )
            .overlay(
                BlobShape()
                    .stroke(neonColor, lineWidth: 4)
            )
    }
}
