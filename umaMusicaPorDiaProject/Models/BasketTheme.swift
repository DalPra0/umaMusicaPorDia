import SwiftUI
import UIKit

struct BasketTheme: Identifiable {
    let id = UUID()
    let name: String
    let folderName: String
    let variants: [String]
    
    var previewImageName: String {
        variants.first ?? ""
    }

    var whiteAssetName: String? {
        let preferredWhiteAsset = "\(folderName)White"
        if UIImage(named: preferredWhiteAsset) != nil {
            return preferredWhiteAsset
        }
        return nil
    }

    var supportsCustomColorSelection: Bool {
        whiteAssetName != nil
    }

    var variantOptions: [BasketVariantOption] {
        variants.map { assetName in
            BasketVariantOption(
                assetName: assetName,
                title: displayName(for: assetName),
                swatchHex: BasketVariantPalette.hex(for: assetName)
            )
        }
    }

    private func displayName(for assetName: String) -> String {
        let knownColors = ["Blue", "Green", "Pink", "Red", "Yellow", "Purple", "Beige"]
        if let color = knownColors.first(where: { assetName.localizedCaseInsensitiveContains($0) }) {
            return color
        }
        return name
    }
}

extension BasketTheme {
    static let allThemes: [BasketTheme] = [
        BasketTheme(name: "AIRPORT BASKET", folderName: "AirportBasket", variants: ["AirportBasket"]),
        BasketTheme(name: "BASKET 1", folderName: "Basket1", variants: ["Basket1Blue", "Basket1Green", "Basket1Pink", "Basket1Red", "Basket1Yellow", "Basket1Purple"]),
        BasketTheme(name: "BASKET 2", folderName: "Basket2", variants: ["Basket2Blue", "Basket2Green", "Basket2Pink", "Basket2Red", "Basket2Yellow"]),
        BasketTheme(name: "BENTO", folderName: "Bento", variants: ["BentoBlue", "BentoGreen", "BentoPink", "BentoRed", "BentoYellow"]),
        BasketTheme(name: "PACKAGING", folderName: "Packaging", variants: ["PackagingBlue", "PackagingGreen", "PackagingPink", "PackagingRed", "PackagingYellow"])
    ]
}
