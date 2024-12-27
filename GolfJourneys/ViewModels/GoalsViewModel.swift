import Foundation
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    @Published private(set) var goals: [Goal] = []
    private let saveKey = "golf_goals"
    
    init() {
        loadGoals()
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveGoals()
    }
    
    func toggleGoalCompletion(_ goalId: UUID) {
        if let index = goals.firstIndex(where: { $0.id == goalId }) {
            var goal = goals[index]
            goal.isCompleted.toggle()
            goal.completedDate = goal.isCompleted ? Date() : nil
            goals[index] = goal
            saveGoals()
        }
    }
    
    func updateGoal(_ updatedGoal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == updatedGoal.id }) {
            goals[index] = updatedGoal
            saveGoals()
        }
    }
    
    func deleteGoal(_ id: UUID) {
        goals.removeAll { goal in
            goal.id == id
        }
        saveGoals()
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