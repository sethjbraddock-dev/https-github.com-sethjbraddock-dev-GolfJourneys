import Foundation
import SwiftUI

@MainActor
class JourneyViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    private let saveKey = "golf_goals"
    
    init() {
        loadGoals()
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveGoals()
    }
    
    func completeGoal(_ goalId: UUID) {
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            var goal = goals[index]
            goal.isCompleted = true
            goal.completedDate = Date()
            goals[index] = goal
            saveGoals()
        }
    }
    
    private func saveGoals() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(goals)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Error saving goals: \(error)")
        }
    }
    
    private func loadGoals() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        
        do {
            let decoder = JSONDecoder()
            goals = try decoder.decode([Goal].self, from: data)
        } catch {
            print("Error loading goals: \(error)")
        }
    }
}
