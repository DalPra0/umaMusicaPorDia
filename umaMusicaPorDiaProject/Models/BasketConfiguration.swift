import SwiftUI

struct BasketConfiguration: Equatable {
    let themeName: String
    let themeFolderName: String
    let allowsCustomTint: Bool
    let variantAssetNames: [String]
    let baseAssetName: String
    var tintHex: String?

    var tintColor: Color? {
        guard let tintHex else { return nil }
        return Color(hex: tintHex)
    }

    static let defaultTintHex = "81E862"
    static let swatchHexes: [String] = [
        "81E862",
        "6759F1",
        "FC02B2",
        "4A90E2",
        "5CC489",
        "F4C542",
        "F67280",
        "F08A5D",
        "8B5CF6",
        "374151"
    ]
}

struct BasketVariantOption: Identifiable, Equatable {
    let assetName: String
    let title: String
    let swatchHex: String?

    var id: String { assetName }
}

enum BasketVariantPalette {
    static func hex(for assetName: String) -> String? {
        let lowercased = assetName.lowercased()
        if lowercased.contains("blue") { return "4A90E2" }
        if lowercased.contains("green") { return "5CC489" }
        if lowercased.contains("pink") { return "F67280" }
        if lowercased.contains("red") { return "E85D5D" }
        if lowercased.contains("yellow") { return "F4C542" }
        if lowercased.contains("purple") { return "8B5CF6" }
        if lowercased.contains("beige") { return "C9B29B" }
        return nil
    }
}

enum BasketColorAccessPolicy {
    // Troque para true quando quiser que personalização de cor seja premium.
    static var customColorRequiresPremium = true

    static func canCustomizeColor(isPremium: Bool) -> Bool {
        !customColorRequiresPremium || isPremium
    }
}
