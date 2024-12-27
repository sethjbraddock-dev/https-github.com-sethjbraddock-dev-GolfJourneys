import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GoalsViewModel()
    @StateObject private var userSettings = UserSettings()
    
    var body: some View {
        GoalsListView(viewModel: viewModel, userSettings: userSettings)
            .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
