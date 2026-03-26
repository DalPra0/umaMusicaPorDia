import SwiftUI
import PhotosUI

struct CollageCreatorView: View {
    @State private var viewModel = CollageViewModel()
    @State private var selectedItems: [PhotosPickerItem] = []
    
    // UI States
    @State private var showLayers = false
    @State private var showImageSource = false
    @State private var showPinterestAssets = false // Nova sheet de assets
    @State private var showPhotosPicker = false
    
    @State private var renderedImage: UIImage?
    @State private var navigateToExport = false
    
    @State private var homeViewModel = HomeViewModel()
    
    @Environment(\.dismiss) var dismiss

    var captureCanvas: some View {
        ZStack {
            viewModel.canvasColor
            
            ForEach(viewModel.items) { item in
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
                    .background(viewModel.canvasColor)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                
                Spacer()
                
                bottomBar
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToExport) {
            if let image = renderedImage {
                ExportView(renderedImage: image)
            }
        }
        .sheet(isPresented: $showLayers) {
            LayersSheet(items: $viewModel.items, onSaveState: { viewModel.saveState() })
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showImageSource) {
            ImageSourceSheet(
                onSelectPhotos: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showPhotosPicker = true
                    }
                },
                onSelectPinterest: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showPinterestAssets = true
                    }
                }
            )
        }
        .sheet(isPresented: $showPinterestAssets) {
            PinterestAssetsSheet(viewModel: viewModel)
                .presentationDetents([.large]) // Quase tela cheia como no design
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItems, matching: .images)
        .onChange(of: selectedItems) { _, _ in loadSelectedImages() }
    }
    
    // MARK: - Subviews
    
    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: { viewModel.undo() }) {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .font(.system(size: 24))
                        .foregroundColor(viewModel.canUndo ? .black : .gray)
                }
                .disabled(!viewModel.canUndo)
                
                Button(action: { viewModel.redo() }) {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .font(.system(size: 24))
                        .foregroundColor(viewModel.canRedo ? .black : .gray)
                }
                .disabled(!viewModel.canRedo)
            }
            
            Spacer()
            
            Button(action: prepareExport) {
                if viewModel.isSaving {
                    ProgressView()
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
            }
            .disabled(viewModel.isSaving || viewModel.items.isEmpty)
        }
    }
    
    private var titleArea: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("A palavra do dia é:")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(-0.31)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(homeViewModel.dailyWord?.word.uppercased() ?? "CARREGANDO...")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(hex: "4A4242"))
                .tracking(0.4)
        }
    }
    
    private var interactiveCanvas: some View {
        ZStack {
            ForEach($viewModel.items) { $item in
                CollageItemView(item: $item, onInteractionEnded: { viewModel.saveState() })
            }
        }
    }
    
    private var bottomBar: some View {
        HStack {
            bottomBarButton(title: "Layers", icon: "square.3.layers.3d") {
                showLayers = true
            }
            
            bottomBarButton(title: "Images", icon: "photo") {
                showImageSource = true
            }
            
            bottomBarButton(title: "Canvas", icon: "arrow.up.left.and.arrow.down.right") {
                viewModel.toggleCanvasColor()
            }
        }
    }
    
    private func bottomBarButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Logic
    
    private func loadSelectedImages() {
        for item in selectedItems {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run { viewModel.addItem(uiImage) }
                }
            }
        }
        selectedItems = []
    }
    
    @MainActor
    private func prepareExport() {
        let renderer = ImageRenderer(content: captureCanvas)
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage,
           let imageData = uiImage.jpegData(compressionQuality: 0.8) {
            
            self.renderedImage = uiImage
            
            let assets = viewModel.items.map { item in
                CollageAsset(id: item.id.uuidString, x: Double(item.offset.width), y: Double(item.offset.height),
                             scale: Double(item.scale), rotation: item.rotation.degrees, type: "image")
            }
            
            Task {
                await viewModel.saveCollage(wordId: homeViewModel.dailyWord?.id ?? UUID(), imageData: imageData, assets: assets)
                navigateToExport = true
            }
        }
    }
}

// MARK: - Subcomponentes

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

struct CollageItemView: View {
    @Binding var item: CollageItem
    var onInteractionEnded: () -> Void
    
    var body: some View {
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
                        onInteractionEnded()
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in item.scale = item.lastScale * value }
                    .onEnded { _ in
                        item.lastScale = item.scale
                        onInteractionEnded()
                    }
                    .simultaneously(with: RotationGesture()
                        .onChanged { value in item.rotation = item.lastRotation + value }
                        .onEnded { _ in
                            item.lastRotation = item.rotation
                            onInteractionEnded()
                        }
                    )
            )
    }
}
