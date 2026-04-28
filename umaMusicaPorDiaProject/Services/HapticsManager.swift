import Foundation
import UIKit

@MainActor
final class HapticsManager {
    static let shared = HapticsManager()

    enum Level: Int, CaseIterable, Identifiable {
        case off = 0
        case soft = 1
        case medium = 2
        case strong = 3

        var id: Int { rawValue }

        var title: String {
            switch self {
            case .off: return "Desligado"
            case .soft: return "Suave"
            case .medium: return "Médio"
            case .strong: return "Forte"
            }
        }

        var selectionIntensity: CGFloat {
            switch self {
            case .off: return 0
            case .soft: return 0.35
            case .medium: return 0.65
            case .strong: return 1.0
            }
        }

        var releaseIntensity: CGFloat {
            switch self {
            case .off: return 0
            case .soft: return 0.45
            case .medium: return 0.75
            case .strong: return 1.0
            }
        }
    }

    private enum Keys {
        static let level = "haptics.level"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        userDefaults.register(defaults: [Keys.level: Level.medium.rawValue])
    }

    var level: Level {
        get {
            let rawValue = userDefaults.integer(forKey: Keys.level)
            return Level(rawValue: rawValue) ?? .medium
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Keys.level)
        }
    }

    var isEnabled: Bool {
        level != .off
    }

    func playSelection() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred(intensity: level.selectionIntensity)
    }

    func playRelease() {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        generator.impactOccurred(intensity: level.releaseIntensity)
    }

    func playNotificationReceived() {
        guard isEnabled else { return }
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        notification.notificationOccurred(.success)
    }

    func playSpinDecelerationPattern(duration: TimeInterval = 2.4) async {
        guard isEnabled else { return }

        let currentLevel = level
        let startIntervalNanos: UInt64
        let endIntervalNanos: UInt64

        switch currentLevel {
        case .off:
            return
        case .soft:
            startIntervalNanos = 90_000_000
            endIntervalNanos = 260_000_000
        case .medium:
            startIntervalNanos = 65_000_000
            endIntervalNanos = 220_000_000
        case .strong:
            startIntervalNanos = 45_000_000
            endIntervalNanos = 180_000_000
        }

        let start = Date()
        while Date().timeIntervalSince(start) < duration {
            guard !Task.isCancelled else { break }
            let elapsed = Date().timeIntervalSince(start)
            let progress = min(max(elapsed / duration, 0), 1)

            let nanos = UInt64(Double(startIntervalNanos) + (Double(endIntervalNanos - startIntervalNanos) * progress))
            let intensity = max(currentLevel.releaseIntensity * (1 - (progress * 0.7)), 0.2)

            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)

            try? await Task.sleep(nanoseconds: nanos)
        }
    }
}
