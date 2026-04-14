import SwiftUI
import PhotosUI

struct CollageCreatorView: View {
    @State private var viewModel: CollageViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    
    init(backgroundImageName: String? = nil) {
        _viewModel = State(initialValue: CollageViewModel(backgroundImageName: backgroundImageName))
    }
    
    @State private var showLayers = false
    @State private var showImageSource = false
    @State private var showPinterestAssets = false
    @State private var showPhotosPicker = false
    @State private var showCanvasSettings = false
    
    @State private var renderedImage: UIImage?
    @State private var navigateToExport = false
    
    @State private var homeViewModel = HomeViewModel()
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                navigationToolbar
                    .padding(.horizontal, 16)
                    .padding(.top, 63)
                
                wordHeader
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                canvasContainer
                
                Spacer()
                
                bottomToolbar
                    .padding(.horizontal, 48)
                    .padding(.bottom, 58)
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
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showCanvasSettings) {
            CanvasSettingsSheet(viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showBackgroundRefinement) {
            if let id = viewModel.selectedItemId,
               let item = viewModel.items.first(where: { $0.id == id }) {
                BackgroundRefinementView(
                    originalImage: item.originalImage,
                    initialMask: item.maskImage,
                    onSave: { refinedImage, refinedMask in
                        viewModel.applyRefinedMask(image: refinedImage, mask: refinedMask)
                    }
                )
            }
        }
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedItems, matching: .images)
        .onChange(of: selectedItems) { _, _ in loadSelectedImages() }
    }
    
    
    private var navigationToolbar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color(hex: "6759F1"))
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: { viewModel.undo() }) {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .font(.system(size: 24))
                        .foregroundStyle(viewModel.canUndo ? Color(hex: "6759F1") : Color.gray)
                }
                .disabled(!viewModel.canUndo)
                
                Button(action: { viewModel.redo() }) {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .font(.system(size: 24))
                        .foregroundStyle(viewModel.canRedo ? Color(hex: "6759F1") : Color.gray)
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
                        .foregroundStyle(Color(hex: "6759F1"))
                }
            }
            .disabled(viewModel.isSaving || viewModel.items.isEmpty)
        }
    }
    
    private var wordHeader: some View {
        VStack(spacing: 0) {
            Text("A palavra do dia é:")
                .font(.system(size: 16))
                .foregroundStyle(Color(hex: "6759F1"))
                .tracking(-0.31)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text(homeViewModel.dailyWord?.word.uppercased() ?? "CARREGANDO...")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color(hex: "6759F1"))
                .tracking(0.4)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var canvasContainer: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color(hex: "6759F1"), lineWidth: 1)
            .frame(width: 302, height: 494)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
            )
            .overlay(alignment: .top) {
                mainCanvas
                    .frame(width: 259, height: 412)
                    .clipped()
                    .background(viewModel.canvasColor)
                    .padding(.top, 32)
            }
    }
    
    private var mainCanvas: some View {
        ZStack {
            Color.white.opacity(0.001)
                .onTapGesture {
                    viewModel.selectItem(nil)
                }
            
            ForEach($viewModel.items) { $item in
                CollageItemView(
                    item: $item,
                    isSelected: viewModel.selectedItemId == item.id,
                    onSelect: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectItem(item.id)
                        }
                    },
                    onInteractionEnded: { viewModel.saveState() }
                )
                .zIndex(viewModel.selectedItemId == item.id ? 100 : 0)
            }
        }
    }
    
    private var bottomToolbar: some View {
        HStack(spacing: 66) {
            ToolbarButton(title: "Camadas", icon: "square.3.layers.3d") {
                showLayers = true
            }
            
            if let selectedId = viewModel.selectedItemId,
               let item = viewModel.items.first(where: { $0.id == selectedId }) {
                ToolbarButton(
                    title: "Fundo",
                    icon: item.isBackgroundRemoved ? "wand.and.stars" : "photo.on.rectangle.angled",
                    isLoading: viewModel.isProcessing
                ) {
                    Task {
                        await viewModel.removeBackgroundOfSelectedItem()
                    }
                }
                .disabled(viewModel.isProcessing)
            } else {
                ToolbarButton(title: "Fundo", icon: "photo.on.rectangle.angled") {
                    showImageSource = true
                }
            }
            
            ToolbarButton(title: "Formatos", icon: "crop.rotate") {
                showCanvasSettings = true
            }
        }
    }
    
    private func ToolbarButton(title: String, icon: String, isLoading: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color(hex: "6759F1"))
                        .frame(width: 53, height: 53)
                    
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(width: 24, height: 24)
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                }
                
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color(hex: "6759F1"))
            }
        }
    }
    
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
        let renderer = ImageRenderer(content: CollageCanvasView(viewModel: viewModel))
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage {
            self.renderedImage = uiImage
            
            let assets = viewModel.items.map { item in
                CollageAsset(id: item.id.uuidString, x: Double(item.offset.width), y: Double(item.offset.height),
                             scale: Double(item.scale), rotation: item.rotation.degrees, type: "image")
            }
            
            Task {
                await viewModel.saveCollage(wordId: homeViewModel.dailyWord?.id ?? UUID(), image: uiImage, assets: assets)
                navigateToExport = true
            }
        }
    }
}
