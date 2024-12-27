import Foundation

@MainActor
class UserSettings: ObservableObject {
    @Published var firstName: String {
        didSet {
            UserDefaults.standard.set(firstName, forKey: "userFirstName")
        }
    }
    
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.firstName = UserDefaults.standard.string(forKey: "userFirstName") ?? ""
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
} 