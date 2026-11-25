import SwiftUI

@main
struct EFMApp: App {
    @StateObject private var reminderManager = ReminderManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reminderManager)
                .tint(EFMTheme.blue)
        }
    }
}
