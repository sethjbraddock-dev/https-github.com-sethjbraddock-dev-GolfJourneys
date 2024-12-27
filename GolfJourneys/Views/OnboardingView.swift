import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userSettings: UserSettings
    @State private var firstName = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to Golf Goals!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Text("Let's personalize your experience")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                TextField("Your first name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                Button("Get Started") {
                    userSettings.firstName = firstName
                    userSettings.hasCompletedOnboarding = true
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: "256142"))
                .disabled(firstName.isEmpty)
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
} 