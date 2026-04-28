import SwiftUI

enum CollageStatePersistence {

    // MARK: - Codable Structs

    struct PersistedCollageState: Codable {
        let wordId: String
        let canvasColorHex: String
        let canvasRatio: String
        let backgroundImageFilename: String?
        let items: [PersistedItem]
    }

    struct PersistedItem: Codable {
        let id: String
        let imageFilename: String
        let originalImageFilename: String
        let maskImageFilename: String?
        let isBasket: Bool
        let basketBaseAssetName: String?
        let basketThemeFolderName: String?
        let basketSupportsCustomTint: Bool
        let basketVariantAssetNames: [String]?
        let basketTintHex: String?
        let isBackgroundRemoved: Bool
        let offsetWidth: Double
        let offsetHeight: Double
        let lastOffsetWidth: Double
        let lastOffsetHeight: Double
        let scale: Double
        let lastScale: Double
        let rotationDegrees: Double
        let lastRotationDegrees: Double
        let strokeColorHex: String
        let strokeWidth: Double
    }

    // MARK: - Directory

    private static func stateDirectory(wordId: UUID) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("collage_state/\(wordId.uuidString)", isDirectory: true)
    }

    // MARK: - Save

    static func save(viewModel: CollageViewModel, wordId: UUID) {
        let dir = stateDirectory(wordId: wordId)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        var persistedItems: [PersistedItem] = []

        for item in viewModel.items {
            let imageFilename = "item_\(item.id.uuidString).jpg"
            let originalFilename = "item_\(item.id.uuidString)_original.jpg"
            var maskFilename: String? = nil

            if let data = item.image.jpegData(compressionQuality: 0.85) {
                try? data.write(to: dir.appendingPathComponent(imageFilename))
            }
            if let data = item.originalImage.jpegData(compressionQuality: 0.85) {
                try? data.write(to: dir.appendingPathComponent(originalFilename))
            }
            if let mask = item.maskImage, let data = mask.pngData() {
                maskFilename = "item_\(item.id.uuidString)_mask.png"
                try? data.write(to: dir.appendingPathComponent(maskFilename!))
            }

            persistedItems.append(PersistedItem(
                id: item.id.uuidString,
                imageFilename: imageFilename,
                originalImageFilename: originalFilename,
                maskImageFilename: maskFilename,
                isBasket: item.isBasket,
                basketBaseAssetName: item.basketBaseAssetName,
                basketThemeFolderName: item.basketThemeFolderName,
                basketSupportsCustomTint: item.basketSupportsCustomTint,
                basketVariantAssetNames: item.basketVariantAssetNames,
                basketTintHex: item.basketTintHex,
                isBackgroundRemoved: item.isBackgroundRemoved,
                offsetWidth: Double(item.offset.width),
                offsetHeight: Double(item.offset.height),
                lastOffsetWidth: Double(item.lastOffset.width),
                lastOffsetHeight: Double(item.lastOffset.height),
                scale: Double(item.scale),
                lastScale: Double(item.lastScale),
                rotationDegrees: item.rotation.degrees,
                lastRotationDegrees: item.lastRotation.degrees,
                strokeColorHex: item.strokeColorHex,
                strokeWidth: Double(item.strokeWidth)
            ))
        }

        var backgroundFilename: String? = nil
        if let bg = viewModel.canvasBackgroundImage,
           let data = bg.jpegData(compressionQuality: 0.85) {
            backgroundFilename = "background.jpg"
            try? data.write(to: dir.appendingPathComponent("background.jpg"))
        }

        let colorHex = viewModel.canvasColor.toHex() ?? "FFFFFF"
        let state = PersistedCollageState(
            wordId: wordId.uuidString,
            canvasColorHex: colorHex,
            canvasRatio: viewModel.canvasRatio.rawValue,
            backgroundImageFilename: backgroundFilename,
            items: persistedItems
        )

        if let data = try? JSONEncoder().encode(state) {
            try? data.write(to: dir.appendingPathComponent("metadata.json"))
        }
    }

    // MARK: - Load

    static func load(wordId: UUID) -> RestoredCollageState? {
        let dir = stateDirectory(wordId: wordId)
        let metaURL = dir.appendingPathComponent("metadata.json")

        guard let data = try? Data(contentsOf: metaURL),
              let persisted = try? JSONDecoder().decode(PersistedCollageState.self, from: data) else {
            return nil
        }

        var items: [CollageItem] = []
        for p in persisted.items {
            let imageURL = dir.appendingPathComponent(p.imageFilename)
            let originalURL = dir.appendingPathComponent(p.originalImageFilename)

            guard let imageData = try? Data(contentsOf: imageURL),
                  let image = UIImage(data: imageData),
                  let originalData = try? Data(contentsOf: originalURL),
                  let originalImage = UIImage(data: originalData) else {
                continue
            }

            var maskImage: UIImage? = nil
            if let maskFilename = p.maskImageFilename,
               let maskData = try? Data(contentsOf: dir.appendingPathComponent(maskFilename)) {
                maskImage = UIImage(data: maskData)
            }

            let item = CollageItem(
                id: UUID(uuidString: p.id) ?? UUID(),
                image: image,
                originalImage: originalImage,
                isBasket: p.isBasket,
                basketBaseAssetName: p.basketBaseAssetName,
                basketThemeFolderName: p.basketThemeFolderName,
                basketSupportsCustomTint: p.basketSupportsCustomTint,
                basketVariantAssetNames: p.basketVariantAssetNames,
                basketTintHex: p.basketTintHex,
                maskImage: maskImage,
                isBackgroundRemoved: p.isBackgroundRemoved,
                offset: CGSize(width: p.offsetWidth, height: p.offsetHeight),
                lastOffset: CGSize(width: p.lastOffsetWidth, height: p.lastOffsetHeight),
                scale: p.scale,
                lastScale: p.lastScale,
                rotation: .degrees(p.rotationDegrees),
                lastRotation: .degrees(p.lastRotationDegrees),
                strokeColorHex: p.strokeColorHex,
                strokeWidth: p.strokeWidth
            )
            items.append(item)
        }

        var backgroundImage: UIImage? = nil
        if let bgFilename = persisted.backgroundImageFilename,
           let bgData = try? Data(contentsOf: dir.appendingPathComponent(bgFilename)) {
            backgroundImage = UIImage(data: bgData)
        }

        let canvasColor = Color(hex: persisted.canvasColorHex)
        let canvasRatio = CollageViewModel.CanvasRatio(rawValue: persisted.canvasRatio) ?? .story

        return RestoredCollageState(
            items: items,
            canvasColor: canvasColor,
            canvasRatio: canvasRatio,
            canvasBackgroundImage: backgroundImage
        )
    }

    // MARK: - Clear

    static func clear(wordId: UUID) {
        let dir = stateDirectory(wordId: wordId)
        try? FileManager.default.removeItem(at: dir)
    }
}

struct RestoredCollageState {
    let items: [CollageItem]
    let canvasColor: Color
    let canvasRatio: CollageViewModel.CanvasRatio
    let canvasBackgroundImage: UIImage?
}
