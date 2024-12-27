import SwiftUI

struct FairwayButtonStyle: ButtonStyle {
    let isDestructive: Bool
    
    init(isDestructive: Bool = false) {
        self.isDestructive = isDestructive
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(isDestructive ? .red : Color(hex: "256142"))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
} 