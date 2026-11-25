import SwiftUI

struct ContentView: View {
    @AppStorage("efm.hasSeenWelcome") private var hasSeenWelcome = false
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if !hasSeenWelcome {
                WelcomeView {
                    hasSeenWelcome = true
                }
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem { Label("Home", systemImage: "house.fill") }
                        .tag(0)
                    LessonsView()
                        .tabItem { Label("Lessons", systemImage: "book.closed.fill") }
                        .tag(1)
                    VocabularyView()
                        .tabItem { Label("Words", systemImage: "character.book.closed.fill") }
                        .tag(2)
                    SettingsView()
                        .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                        .tag(3)
                }
                .tint(EFMTheme.blue)
            }
        }
        .preferredColorScheme(.light)
    }
}

struct WelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            EFMTheme.background.ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 34)
                        .fill(LinearGradient(colors: [EFMTheme.blue, EFMTheme.deepBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 126, height: 126)
                        .shadow(color: EFMTheme.blue.opacity(0.25), radius: 18, y: 10)
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 46, weight: .semibold))
                        .foregroundStyle(.white)
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 19))
                                .foregroundStyle(.white)
                                .offset(x: 10, y: -15)
                        }
                }
                VStack(spacing: 6) {
                    Text("EFM").font(.system(size: 42, weight: .black, design: .rounded)).foregroundStyle(EFMTheme.deepBlue)
                    Text("English For Me").font(.title3.weight(.semibold)).foregroundStyle(EFMTheme.ink)
                    Text("Learn English. Build Confidence. Every Day.")
                        .font(.subheadline).foregroundStyle(EFMTheme.muted)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                Spacer()
                Button(action: onContinue) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(EFMTheme.blue, in: RoundedRectangle(cornerRadius: 18))
                }
                .padding(.bottom, 24)
            }
            .padding(28)
        }
    }
}

struct HomeView: View {
    private let features: [Feature] = [
        .init(title: "Lessons", subtitle: "Structured courses", icon: "book.closed.fill"),
        .init(title: "Vocabulary", subtitle: "Words & expressions", icon: "character.book.closed.fill"),
        .init(title: "Speaking", subtitle: "Conversation practice", icon: "bubble.left.and.bubble.right.fill"),
        .init(title: "Listening", subtitle: "Audio exercises", icon: "headphones"),
        .init(title: "Quiz", subtitle: "Test your knowledge", icon: "checklist"),
        .init(title: "My Progress", subtitle: "Track your learning", icon: "chart.bar.fill")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hello, Learner 👋").font(.subheadline.weight(.medium)).foregroundStyle(EFMTheme.muted)
                            Text("Ready to learn today?").font(.title2.bold()).foregroundStyle(EFMTheme.ink)
                        }
                        Spacer()
                        Image(systemName: "bell.badge.fill")
                            .font(.title2).foregroundStyle(EFMTheme.blue)
                            .padding(12).background(.white, in: Circle())
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("YOUR LEARNING JOURNEY").font(.caption.weight(.bold)).foregroundStyle(.white.opacity(0.8))
                                Text("Small steps, big progress").font(.title3.bold()).foregroundStyle(.white)
                                Text("Start with a lesson today").font(.subheadline).foregroundStyle(.white.opacity(0.85))
                            }
                            Spacer()
                            Image(systemName: "graduationcap.fill").font(.system(size: 42)).foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [EFMTheme.blue, EFMTheme.deepBlue], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 24))

                    Text("Explore Learning").font(.title3.bold()).foregroundStyle(EFMTheme.ink)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(features) { feature in
                            FeatureCard(feature: feature)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Daily goal", systemImage: "target").font(.headline).foregroundStyle(EFMTheme.ink)
                        Text("Spend 15 minutes with English today.")
                            .font(.subheadline).foregroundStyle(EFMTheme.muted)
                        ProgressView(value: 0.25)
                            .tint(EFMTheme.blue)
                    }
                    .padding(16)
                    .background(.white, in: RoundedRectangle(cornerRadius: 20))
                }
                .padding(18)
            }
            .background(EFMTheme.background)
            .navigationBarHidden(true)
        }
    }
}

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
}

struct FeatureCard: View {
    let feature: Feature
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: feature.icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(EFMTheme.blue)
                .frame(width: 48, height: 48)
                .background(EFMTheme.paleBlue, in: RoundedRectangle(cornerRadius: 15))
            Text(feature.title).font(.headline).foregroundStyle(EFMTheme.ink)
            Text(feature.subtitle).font(.caption).foregroundStyle(EFMTheme.muted)
        }
        .frame(maxWidth: .infinity, minHeight: 126, alignment: .leading)
        .padding(15)
        .background(.white, in: RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(EFMTheme.paleBlue, lineWidth: 1))
    }
}

struct LessonsView: View {
    private let levels = [
        ("A1", "Beginner", "Everyday words and simple sentences"),
        ("A2", "Elementary", "Common situations and basic conversations"),
        ("B1", "Intermediate", "Work, travel and personal experiences"),
        ("B2", "Upper Intermediate", "Fluent communication and detailed topics"),
        ("C1", "Advanced", "Complex texts and confident expression"),
        ("C2", "Proficiency", "Precise and flexible English use")
    ]
    var body: some View {
        NavigationStack {
            List {
                Section("Choose your level") {
                    ForEach(levels, id: \.0) { level in
                        HStack(spacing: 14) {
                            Text(level.0).font(.headline).foregroundStyle(.white)
                                .frame(width: 48, height: 48)
                                .background(EFMTheme.blue, in: RoundedRectangle(cornerRadius: 14))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(level.1).font(.headline)
                                Text(level.2).font(.caption).foregroundStyle(EFMTheme.muted)
                            }
                        }.padding(.vertical, 5)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(EFMTheme.background)
            .navigationTitle("Lessons")
        }
    }
}

struct VocabularyView: View {
    private let words = [
        ("confident", "feeling sure about yourself", "She feels confident when speaking English."),
        ("opportunity", "a chance to do something", "This is a great opportunity to learn."),
        ("improve", "to become better", "I want to improve my English.")
    ]
    var body: some View {
        NavigationStack {
            List {
                Section("Starter vocabulary") {
                    ForEach(words, id: \.0) { word in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(word.0).font(.headline).foregroundStyle(EFMTheme.deepBlue)
                                Spacer()
                                Image(systemName: "speaker.wave.2.fill").foregroundStyle(EFMTheme.blue)
                            }
                            Text(word.1).font(.subheadline)
                            Text(word.2).font(.caption).foregroundStyle(EFMTheme.muted)
                        }.padding(.vertical, 6)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(EFMTheme.background)
            .navigationTitle("Vocabulary")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject private var reminderManager: ReminderManager
    var body: some View {
        NavigationStack {
            Form {
                Section("Daily learning reminder") {
                    Toggle("Enable reminder", isOn: $reminderManager.isEnabled)
                        .onChange(of: reminderManager.isEnabled) { enabled in
                            Task { await reminderManager.updateReminder(enabled: enabled) }
                        }
                    DatePicker("Reminder time", selection: $reminderManager.reminderTime, displayedComponents: .hourAndMinute)
                        .onChange(of: reminderManager.reminderTime) { _ in
                            Task { await reminderManager.updateReminder(enabled: reminderManager.isEnabled) }
                        }
                    Text("A gentle daily reminder to keep your English-learning habit going.")
                        .font(.caption).foregroundStyle(EFMTheme.muted)
                }
                Section("About EFM") {
                    LabeledContent("App", value: "EFM – English For Me")
                    LabeledContent("Learning path", value: "A1 – C2")
                    LabeledContent("Version", value: "1.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
