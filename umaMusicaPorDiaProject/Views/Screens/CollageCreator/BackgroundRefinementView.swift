import SwiftUI

struct BackgroundRefinementView: View {
    let originalImage: UIImage
    let initialMask: UIImage?
    let onSave: (UIImage, UIImage) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var brushSize: CGFloat = 30
    @State private var tool: Tool = .erase
    @State private var strokes: [Stroke] = []
    @State private var currentStroke: Stroke?
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    enum Tool {
        case erase
        case restore
    }
    
    struct Stroke: Identifiable {
        let id = UUID()
        var normalizedPoints: [CGPoint]
        var size: CGFloat
        var tool: Tool
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 20) {
                    toolButton(title: "Apagar", icon: "eraser.fill", activeTool: .erase, color: .red)
                    toolButton(title: "Restaurar", icon: "paintbrush.fill", activeTool: .restore, color: .blue)
                    
                    Spacer()
                    
                    Button(action: { strokes.removeAll() }) {
                        Image(systemName: "arrow.uturn.backward.circle")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(Color(hex: "F2F2F2"))
                
                GeometryReader { geometry in
                    let canvasSize = geometry.size
                    
                    ZStack {
                        ZStack {
                            checkerboardBackground
                                .aspectRatio(originalImage.size.width / originalImage.size.height, contentMode: .fit)
                            
                            Image(uiImage: originalImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity(0.15)
                            
                            Image(uiImage: originalImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .mask {
                                    maskCanvas(size: canvasSize)
                                }
                            
                            brushFeedbackCanvas(size: canvasSize)
                                .opacity(0.3)
                        }
                        .scaleEffect(scale)
                        .offset(offset)
                        
                        touchArea(size: canvasSize)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                }
                .padding()
                
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "minus")
                        Slider(value: $brushSize, in: 5...100)
                        Image(systemName: "plus")
                        
                        Button(action: {
                            scale = 1.0
                            lastScale = 1.0
                            offset = .zero
                        }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal)
                    
                    Text("Tamanho do Pincel: \(Int(brushSize))px")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Ajustar Fundo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salvar") {
                        saveRefinement()
                    }
                }
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let nextScale = lastScale * value
                        scale = min(max(nextScale, 1.0), 4.0)
                    }
                    .onEnded { _ in
                        lastScale = scale
                    }
            )
        }
    }
    
    
    private func maskCanvas(size: CGSize) -> some View {
        Canvas { context, canvasSize in
            context.addFilter(.alphaThreshold(min: 0.01)) // Opcional: Garante bordas limpas
            
            if let mask = initialMask {
                context.draw(Image(uiImage: mask), in: CGRect(origin: .zero, size: canvasSize))
            }
            
            for stroke in strokes + [currentStroke].compactMap({ $0 }) {
                var path = Path()
                if let firstPoint = stroke.normalizedPoints.first {
                    path.move(to: CGPoint(x: firstPoint.x * canvasSize.width, y: firstPoint.y * canvasSize.height))
                    for point in stroke.normalizedPoints.dropFirst() {
                        path.addLine(to: CGPoint(x: point.x * canvasSize.width, y: point.y * canvasSize.height))
                    }
                }
                
                if stroke.tool == .erase {
                    context.blendMode = .destinationOut
                    context.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: stroke.size, lineCap: .round, lineJoin: .round))
                } else {
                    context.blendMode = .normal
                    context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: stroke.size, lineCap: .round, lineJoin: .round))
                }
            }
        }
    }
    
    private func brushFeedbackCanvas(size: CGSize) -> some View {
        Canvas { context, canvasSize in
            if let stroke = currentStroke {
                var path = Path()
                if let firstPoint = stroke.normalizedPoints.first {
                    path.move(to: CGPoint(x: firstPoint.x * canvasSize.width, y: firstPoint.y * canvasSize.height))
                    for point in stroke.normalizedPoints.dropFirst() {
                        path.addLine(to: CGPoint(x: point.x * canvasSize.width, y: point.y * canvasSize.height))
                    }
                }
                let brushColor = stroke.tool == .erase ? Color.red : Color.blue
                context.stroke(path, with: .color(brushColor), style: StrokeStyle(lineWidth: stroke.size, lineCap: .round, lineJoin: .round))
            }
        }
        .aspectRatio(originalImage.size.width / originalImage.size.height, contentMode: .fit)
    }
    
    private func touchArea(size: CGSize) -> some View {
        Color.clear
            .contentShape(Rectangle())
            .aspectRatio(originalImage.size.width / originalImage.size.height, contentMode: .fit)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let x = (value.location.x - offset.width) / scale
                        let y = (value.location.y - offset.height) / scale
                        
                        let normalizedPoint = CGPoint(
                            x: x / size.width,
                            y: y / size.height
                        )
                        
                        if currentStroke == nil {
                            currentStroke = Stroke(normalizedPoints: [normalizedPoint], size: brushSize / scale, tool: tool)
                        } else {
                            currentStroke?.normalizedPoints.append(normalizedPoint)
                        }
                    }
                    .onEnded { _ in
                        if let stroke = currentStroke {
                            strokes.append(stroke)
                        }
                        currentStroke = nil
                    }
            )
    }
    
    private var checkerboardBackground: some View {
        Canvas { context, size in
            let gridSize: CGFloat = 10
            let columns = Int(size.width / gridSize) + 1
            let rows = Int(size.height / gridSize) + 1
            for row in 0..<rows {
                for col in 0..<columns {
                    if (row + col) % 2 == 0 {
                        context.fill(Path(CGRect(x: CGFloat(col) * gridSize, y: CGFloat(row) * gridSize, width: gridSize, height: gridSize)), with: .color(Color.gray.opacity(0.3)))
                    }
                }
            }
        }
        .background(Color.white)
    }
    
    private func toolButton(title: String, icon: String, activeTool: Tool, color: Color) -> some View {
        Button(action: { tool = activeTool }) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 12, weight: .bold))
            }
            .foregroundColor(tool == activeTool ? color : .gray)
            .frame(width: 80)
            .padding(.vertical, 8)
            .background(tool == activeTool ? color.opacity(0.1) : Color.clear)
            .cornerRadius(10)
        }
    }
    
    @MainActor
    private func saveRefinement() {
        let size = originalImage.size
        let renderer = ImageRenderer(content: maskContentView(size: size))
        renderer.scale = 1.0
        if let maskImage = renderer.uiImage {
            if let finalImage = ImageProcessor.applyMask(to: originalImage, mask: maskImage) {
                onSave(finalImage, maskImage)
            }
        }
    }
    
    private func maskContentView(size: CGSize) -> some View {
        Canvas { context, canvasSize in
            if let mask = initialMask {
                context.draw(Image(uiImage: mask), in: CGRect(origin: .zero, size: canvasSize))
            }
            for stroke in strokes {
                var path = Path()
                if let firstPoint = stroke.normalizedPoints.first {
                    path.move(to: CGPoint(x: firstPoint.x * canvasSize.width, y: firstPoint.y * canvasSize.height))
                    for point in stroke.normalizedPoints.dropFirst() {
                        path.addLine(to: CGPoint(x: point.x * canvasSize.width, y: point.y * canvasSize.height))
                    }
                }
                if stroke.tool == .erase {
                    context.blendMode = .destinationOut
                    context.stroke(path, with: .color(.black), style: StrokeStyle(lineWidth: stroke.size, lineCap: .round, lineJoin: .round))
                } else {
                    context.blendMode = .normal
                    context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: stroke.size, lineCap: .round, lineJoin: .round))
                }
            }
        }
        .frame(width: size.width, height: size.height)
    }
}
