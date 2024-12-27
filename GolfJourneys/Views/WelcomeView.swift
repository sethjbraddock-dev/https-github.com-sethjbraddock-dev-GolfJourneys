import SwiftUI

struct WelcomeView: View {
    @Binding var showNewJourney: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flag.filled.and.flag.crossed")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            
            Text("Welcome to Golf Journey")
                .font(.title)
            
            Text("Track your golf goals and visualize your progress through an 18-hole journey")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            
            Button("Start Your Journey") {
                showNewJourney = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
} 