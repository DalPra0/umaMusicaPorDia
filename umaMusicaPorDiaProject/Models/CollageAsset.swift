import Foundation

struct CollageAsset: Codable {
    let id: String
    let x: Double
    let y: Double
    let scale: Double
    let rotation: Double
    let type: String
    let sourceAssetName: String?
    let tintHex: String?
}
