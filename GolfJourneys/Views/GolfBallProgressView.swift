import SwiftUI

struct GolfBallView: View {
    let isCompleted: Bool
    let userName: String
    let ballNumber: Int
    @Environment(\.colorScheme) var colorScheme
    
    // Define dimple positions in a uniform hexagonal pattern
    private let dimplePositions: [(CGFloat, CGFloat)] = {
        var positions: [(CGFloat, CGFloat)] = []
        let rows = 15
        let dimpleSpacing: CGFloat = 0.062
        let verticalOffset: CGFloat = 0.866
        
        for row in -2..<(rows + 3) {
            let isEvenRow = row % 2 == 0
            let rowY = 0.5 + (CGFloat(row - rows/2) * dimpleSpacing * verticalOffset)
            let xOffset = isEvenRow ? 0.0 : dimpleSpacing / 2
            
            for col in -2..<18 {
                let x = 0.5 + xOffset + (CGFloat(col - 8) * dimpleSpacing)
                
                // Calculate distance from center
                let dx = x - 0.5
                let dy = rowY - 0.5
                let distanceFromCenter = sqrt(dx * dx + dy * dy)
                
                if distanceFromCenter <= 0.53 {
                    positions.append((x, rowY))
                }
            }
        }
        
        return positions
    }()
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let dimpleSize = size * 0.062
            
            ZStack {
                // Base ball
                Circle()
                    .fill(.white)
                    .opacity(isCompleted ? 1.0 : 0.2)
                
                // Dimples with clipping
                ForEach(0..<dimplePositions.count, id: \.self) { index in
                    let position = dimplePositions[index]
                    Circle()
                        .fill(isCompleted ? Color.black.opacity(0.08) : Color.white.opacity(0.15))
                        .frame(width: dimpleSize, height: dimpleSize)
                        .position(
                            x: position.0 * size,
                            y: position.1 * size
                        )
                }
                .clipShape(Circle())
                
                // 3D effect layers
                Circle()
                    .stroke(isCompleted ? .white.opacity(0.4) : .white.opacity(0.2), lineWidth: 1)
                
                // Enhanced gradient overlay for 3D effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: .white.opacity(0.3), location: 0.4),
                                .init(color: .white.opacity(0.0), location: 0.7),
                                .init(color: .black.opacity(0.1), location: 1.0)
                            ]),
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: size * 0.8
                        )
                    )
                
                // Enhanced highlight shine
                Circle()
                    .trim(from: 0.3, to: 0.35)
                    .stroke(.white.opacity(0.8), lineWidth: 1.5)
                    .rotationEffect(.degrees(-45))
                    .opacity(isCompleted ? 1.0 : 0.3)
                
                // Edge highlight
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.4),
                                .white.opacity(0.0),
                                .black.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                
                // Ball branding
                VStack(spacing: -4) {
                    // Name branding
                    Text(userName)
                        .font(.custom("Snell Roundhand", size: size * 0.22))
                        .fontWeight(.regular)
                        .foregroundStyle(
                            isCompleted
                            ? Color.black.opacity(0.4)
                            : colorScheme == .dark
                                ? Color.white.opacity(0.3)
                                : Color.black.opacity(0.15)
                        )
                        .offset(y: -size * 0.03)
                    
                    // Ball number
                    Text("\(ballNumber)")
                        .font(.custom("Snell Roundhand", size: size * 0.18))
                        .fontWeight(.bold)
                        .foregroundStyle(
                            isCompleted
                            ? Color(hex: "256142").opacity(0.8)
                            : colorScheme == .dark
                                ? Color.red.opacity(0.5)
                                : Color.red.opacity(0.7)
                        )
                        .offset(y: size * 0.03)
                }
                .rotationEffect(.degrees(-12))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .shadow(color: .black.opacity(isCompleted ? 0.2 : 0), radius: 2, x: 1, y: 1)
    }
}

struct GolfBallProgressView: View {
    let totalGoals: Int
    let completedGoals: Int
    let maxBallsPerRow: Int = 5
    let userName: String
    
    private var rows: Int {
        (totalGoals + maxBallsPerRow - 1) / maxBallsPerRow
    }
    
    private var progressViewHeight: CGFloat {
        let ballSize: CGFloat = 60
        let rowSpacing: CGFloat = 12
        let textHeight: CGFloat = 20
        let bottomPadding: CGFloat = 32
        
        let ballsHeight = (ballSize * CGFloat(rows)) + (rowSpacing * CGFloat(max(0, rows - 1)))
        return ballsHeight + textHeight + bottomPadding
    }
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let ballSize = (availableWidth - (CGFloat(maxBallsPerRow - 1) * 12)) / CGFloat(maxBallsPerRow)
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(0..<min(maxBallsPerRow, totalGoals - row * maxBallsPerRow), id: \.self) { column in
                                let index = row * maxBallsPerRow + column
                                GolfBallView(
                                    isCompleted: index < completedGoals,
                                    userName: userName,
                                    ballNumber: index + 1
                                )
                                    .frame(width: ballSize, height: ballSize)
                            }
                        }
                    }
                }
                
                Text("\(completedGoals) of \(totalGoals) goals completed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 2)
                    .padding(.bottom, 8)
            }
        }
        .frame(height: progressViewHeight)
    }
}

#Preview {
    GolfBallProgressView(
        totalGoals: 3,
        completedGoals: 1,
        userName: "Preview"
    )
    .padding()
} 
