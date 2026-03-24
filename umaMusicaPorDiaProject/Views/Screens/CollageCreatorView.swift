import SwiftUI
import PhotosUI

// MARK: - Modelos e Helpers

struct CollageItem: Identifiable, Equatable {
    let id: UUID
    var image: UIImage
    var offset: CGSize
    var lastOffset: CGSize
    var scale: CGFloat
    var lastScale: CGFloat
    var rotation: Angle
    var lastRotation: Angle
    
    init(id: UUID = UUID(), image: UIImage, offset: CGSize = .zero, lastOffset: CGSize = .zero, scale: CGFloat = 1.0, lastScale: CGFloat = 1.0, rotation: Angle = .zero, lastRotation: Angle = .zero) {
        self.id = id
        self.image = image
        self.offset = offset
        self.lastOffset = lastOffset
        self.scale = scale
        self.lastScale = lastScale
        self.rotation = rotation
        self.lastRotation = lastRotation
    }
    
    static func == (lhs: CollageItem, rhs: CollageItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.offset == rhs.offset &&
        lhs.scale == rhs.scale &&
        lhs.rotation == rhs.rotation
    }
}

// MARK: - View Principal

struct CollageCreatorView: View {
    @StateObject private var viewModel = MusicViewModel()
    @State private var items: [CollageItem] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    
    @State private var canvasColor: Color = .white
    @State private var undoStack: [[CollageItem]] = []
    @State private var redoStack: [[CollageItem]] = []
    
    @State private var showLayers = false
    @State private var isSaving = false
    
    // Navegação para Exportação
    @State private var renderedImage: UIImage?
    @State private var navigateToExport = false
    
    @Environment(\.dismiss) var dismiss

    var captureCanvas: some View {
        ZStack {
            canvasColor
            
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
        .frame(width: 1080/3, height: 1920/3)
    }

    var body: some View {
        ZStack {
            Color(hex: "D9D9D9")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                
                titleArea
                    .padding(.horizontal, 44)
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                
                interactiveCanvas
                    .frame(width: 302, height: 536)
                    .clipped()
                    .background(canvasColor)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                
                Spacer()
                
                bottomBar
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
        }
        .navigationDestination(isPresented: $navigateToExport) {
            if let image = renderedImage {
                ExportView(renderedImage: image)
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.loadInitialData() }
        .onChange(of: selectedItems) { _, _ in loadSelectedImages() }
        .sheet(isPresented: $showLayers) {
            LayersSheet(items: $items, onSaveState: saveState)
                .presentationDetents([.medium])
        }
    }
    
    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: undo) {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .font(.system(size: 24))
                        .foregroundColor(undoStack.isEmpty ? .gray : .black)
                }
                .disabled(undoStack.isEmpty)
                
                Button(action: redo) {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .font(.system(size: 24))
                        .foregroundColor(redoStack.isEmpty ? .gray : .black)
                }
                .disabled(redoStack.isEmpty)
            }
            
            Spacer()
            
            Button(action: prepareExport) {
                if isSaving {
                    ProgressView()
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            .disabled(isSaving || items.isEmpty)
        }
    }
    
    private var titleArea: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("A palavra do dia é:")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(-0.31)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let word = viewModel.dailyWord {
                Text(word.word.uppercased())
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(Color(hex: "4A4242"))
                    .tracking(0.4)
            } else {
                Text("CARREGANDO...")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var interactiveCanvas: some View {
        ZStack {
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
                            .onEnded { _ in
                                item.lastOffset = item.offset
                                saveState()
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in item.scale = item.lastScale * value }
                            .onEnded { _ in
                                item.lastScale = item.scale
                                saveState()
                            }
                            .simultaneously(with: RotationGesture()
                                .onChanged { value in item.rotation = item.lastRotation + value }
                                .onEnded { _ in
                                    item.lastRotation = item.rotation
                                    saveState()
                                }
                            )
                    )
            }
        }
    }
    
    private var bottomBar: some View {
        HStack {
            Button(action: { showLayers = true }) {
                VStack(spacing: 8) {
                    Image(systemName: "square.3.layers.3d")
                        .font(.system(size: 24))
                    Text("Layers")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
            }
            
            PhotosPicker(selection: $selectedItems, matching: .images) {
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                    Text("Images")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                saveState()
                canvasColor = canvasColor == .white ? Color(hex: "F0F0F0") : .white
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 24))
                    Text("Canvas")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    func loadSelectedImages() {
        for item in selectedItems {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        saveState()
                        items.append(CollageItem(image: uiImage))
                    }
                }
            }
        }
        selectedItems = []
    }
    
    private func saveState() {
        if undoStack.count > 20 { undoStack.removeFirst() }
        undoStack.append(items)
        redoStack.removeAll()
    }
    
    private func undo() {
        guard let lastState = undoStack.popLast() else { return }
        redoStack.append(items)
        items = lastState
    }
    
    private func redo() {
        guard let nextState = redoStack.popLast() else { return }
        undoStack.append(items)
        items = nextState
    }
    
    @MainActor
    func prepareExport() {
        isSaving = true
        
        let renderer = ImageRenderer(content: captureCanvas)
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage,
           let imageData = uiImage.jpegData(compressionQuality: 0.8) {
            
            self.renderedImage = uiImage
            
            let assets = items.map { item in
                CollageAsset(id: item.id.uuidString, x: Double(item.offset.width), y: Double(item.offset.height),
                             scale: Double(item.scale), rotation: item.rotation.degrees, type: "image")
            }
            
            Task {
                await viewModel.saveUserCollage(imageData: imageData, assets: assets)
                isSaving = false
                navigateToExport = true // Navega para a nova tela
            }
        } else {
            isSaving = false
        }
    }
}

struct LayersSheet: View {
    @Binding var items: [CollageItem]
    var onSaveState: () -> Void
    
    var body: some View {
        NavigationView {
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
            .toolbar { EditButton() }
        }
    }
}
