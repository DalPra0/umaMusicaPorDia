import Foundation
import UserNotifications
import Auth

final class NotificationManager {
    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let authService: AuthService
    private let wordService: WordService
    private let collageService: CollageService
    private let userDefaults: UserDefaults

    private(set) var hasCreatedCollageToday = false

    private enum Keys {
        static let lastScheduledDate = "notifications.lastScheduledDate"
    }

    private enum Constants {
        static let reminderCount = 5
        static let reminderIdPrefix = "daily-collage-reminder"
    }

    init(
        authService: AuthService = AuthService(),
        wordService: WordService = WordService(),
        collageService: CollageService = CollageService(),
        userDefaults: UserDefaults = .standard
    ) {
        self.authService = authService
        self.wordService = wordService
        self.collageService = collageService
        self.userDefaults = userDefaults
    }

    func syncDailyRemindersWithCurrentState() async throws {
        guard let userId = authService.currentUser?.id else {
            hasCreatedCollageToday = false
            await clearDailyReminders()
            return
        }

        let dailyWord = try await wordService.fetchDailyWord()
        hasCreatedCollageToday = try await collageService.hasCollage(userId: userId, wordId: dailyWord.id)

        if hasCreatedCollageToday {
            await clearDailyReminders()
            return
        }

        try await requestAuthorizationIfNeeded()
        try await scheduleRandomRemindersIfNeeded(for: dailyWord.word)
    }

    func markCollageAsCreatedToday() async {
        hasCreatedCollageToday = true
        await clearDailyReminders()
    }

    func clearDailyReminders() async {
        center.removePendingNotificationRequests(withIdentifiers: reminderIdentifiers)
    }

    private var reminderIdentifiers: [String] {
        (0..<Constants.reminderCount).map { "\(Constants.reminderIdPrefix)-\($0)" }
    }

    private func requestAuthorizationIfNeeded() async throws {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .notDetermined else { return }
        _ = try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    private func scheduleRandomRemindersIfNeeded(for dailyWord: String) async throws {
        let todayKey = formattedDayKey(from: Date())
        let alreadyScheduledToday = userDefaults.string(forKey: Keys.lastScheduledDate) == todayKey

        if alreadyScheduledToday {
            let pendingCount = await pendingReminderRequestCount()
            if pendingCount == Constants.reminderCount {
                return
            }
        }

        center.removePendingNotificationRequests(withIdentifiers: reminderIdentifiers)

        let reminderTimes = randomReminderTimes(count: Constants.reminderCount)
        for (index, components) in reminderTimes.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = "Lembrete \(index + 1)/\(Constants.reminderCount)"
            content.body = "A palavra de hoje é \(dailyWord.uppercased()). Bora fazer sua colagem?"
            content.sound = .default
            content.userInfo = [
                "reminder_index": index + 1,
                "daily_word": dailyWord
            ]

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: DateComponents(hour: components.hour, minute: components.minute),
                repeats: true
            )

            let request = UNNotificationRequest(
                identifier: reminderIdentifiers[index],
                content: content,
                trigger: trigger
            )

            try await add(request: request)
        }

        userDefaults.set(todayKey, forKey: Keys.lastScheduledDate)
    }

    private func pendingReminderRequestCount() async -> Int {
        await withCheckedContinuation { continuation in
            center.getPendingNotificationRequests { requests in
                let count = requests.filter { $0.identifier.hasPrefix(Constants.reminderIdPrefix) }.count
                continuation.resume(returning: count)
            }
        }
    }

    private func randomReminderTimes(count: Int) -> [(hour: Int, minute: Int)] {
        let minutesRange = Array((8 * 60)..<(22 * 60))
        let selected = minutesRange.shuffled().prefix(count).sorted()

        return selected.map { minuteOfDay in
            let hour = minuteOfDay / 60
            let minute = minuteOfDay % 60
            return (hour, minute)
        }
    }

    private func formattedDayKey(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func add(request: UNNotificationRequest) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            center.add(request) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
}
