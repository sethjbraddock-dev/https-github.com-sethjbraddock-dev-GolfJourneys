import Foundation

// Single source of truth for Goal model
struct Goal: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let description: String
    var isCompleted: Bool
    var completedDate: Date?
    let deadlineDate: Date
    let isHardDeadline: Bool
    
    init(id: UUID = UUID(), 
         title: String, 
         description: String = "", 
         isCompleted: Bool = false, 
         completedDate: Date? = nil, 
         deadlineDate: Date,
         isHardDeadline: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.deadlineDate = deadlineDate
        self.isHardDeadline = isHardDeadline
    }
    
    var daysRemaining: Int {
        if isCompleted { return 0 }
        return Calendar.current.dateComponents([.day], from: Date(), to: deadlineDate).day ?? 0
    }
    
    var isOverdue: Bool {
        !isCompleted && daysRemaining < 0
    }
    
    var daysRemainingText: String {
        if isCompleted { return "" }
        let days = daysRemaining
        if days == 0 {
            return "Due today"
        } else if days < 0 {
            return "Overdue by \(abs(days)) day\(abs(days) == 1 ? "" : "s")"
        } else {
            return "Due in \(days) day\(days == 1 ? "" : "s")"
        }
    }
} 