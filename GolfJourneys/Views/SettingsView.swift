import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userSettings: UserSettings
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $userSettings.isDarkMode)
                        .onChange(of: userSettings.isDarkMode) { _, newValue in
                            // Trigger haptic feedback when changing theme
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        }
                }
                
                Section("Profile") {
                    TextField("Your Name", text: $userSettings.firstName)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .buttonStyle(FairwayButtonStyle())
                }
            }
            .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    SettingsView(userSettings: UserSettings())
} 