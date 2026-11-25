import Combine
import Foundation
import Combine
import UserNotifications

@MainActor
final class ReminderManager: ObservableObject {
    @Published var isEnabled: Bool {
        didSet { UserDefaults.standard.set(isEnabled, forKey: "efm.reminder.enabled") }
    }
    @Published var reminderTime: Date {
        didSet { UserDefaults.standard.set(reminderTime, forKey: "efm.reminder.time") }
    }

    init() {
        self.isEnabled = UserDefaults.standard.object(forKey: "efm.reminder.enabled") as? Bool ?? false
        self.reminderTime = UserDefaults.standard.object(forKey: "efm.reminder.time") as? Date ?? Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? .now
    }

    func updateReminder(enabled: Bool) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["efm.daily.learning"])

        guard enabled else { return }

        let settings = await center.notificationSettings()
        var authorized = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
        if !authorized {
            do {
                authorized = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                authorized = false
            }
        }
        guard authorized else {
            isEnabled = false
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Time for English! 📘"
        content.body = "Take 15 minutes today to build your English skills with EFM."
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "efm.daily.learning", content: content, trigger: trigger)
        do {
            try await center.add(request)
        } catch {
            isEnabled = false
        }
    }
}
