import SwiftUI

struct GoalRowView: View {
    let goal: Goal
    let onComplete: () -> Void
    @State private var showingEditSheet = false
    @ObservedObject var viewModel: GoalsViewModel
    
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        HStack {
            // Goal content - tappable for edit
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.title)
                            .font(.headline)
                            .strikethrough(goal.isCompleted)
                        
                        if !goal.description.isEmpty {
                            Text(goal.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                if !goal.isCompleted {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundStyle(.secondary)
                        Text(goal.daysRemainingText)
                            .font(.caption)
                            .foregroundStyle(goal.isOverdue ? .red : .secondary)
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showingEditSheet = true
            }
            
            // Completion button
            Button {
                hapticFeedback.prepare()
                onComplete()
                if !goal.isCompleted {
                    hapticFeedback.notificationOccurred(.success)
                } else {
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
            } label: {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(goal.isCompleted ? Color(hex: "256142") : .secondary)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditGoalView(goal: goal, viewModel: viewModel)
        }
    }
}

struct EditGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GoalsViewModel
    let goal: Goal
    
    @State private var title: String
    @State private var description: String
    @State private var deadline: Date
    @State private var showingDeleteConfirmation = false
    
    init(goal: Goal, viewModel: GoalsViewModel) {
        self.goal = goal
        self.viewModel = viewModel
        _title = State(initialValue: goal.title)
        _description = State(initialValue: goal.description)
        _deadline = State(initialValue: goal.deadlineDate)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Goal Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    DatePicker("Target Date", selection: $deadline, displayedComponents: .date)
                        .disabled(goal.isHardDeadline)
                    
                    if goal.isHardDeadline {
                        Text("This is a hard deadline and cannot be changed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Goal")
                        }
                    }
                }
            }
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(FairwayButtonStyle(isDestructive: true))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Update goal logic here
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .buttonStyle(FairwayButtonStyle())
                }
            }
            .confirmationDialog(
                "Delete Goal",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    withAnimation {
                        viewModel.deleteGoal(goal.id)
                        dismiss()
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this goal? This action cannot be undone.")
            }
        }
    }
} 