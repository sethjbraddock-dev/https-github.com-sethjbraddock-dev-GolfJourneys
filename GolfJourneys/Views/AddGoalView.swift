import SwiftUI

struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GoalsViewModel
    @FocusState private var focusedField: Field?
    
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Date()
    @State private var isHardDeadline = false
    
    enum Field {
        case title, description
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Goal Title", text: $title)
                        .focused($focusedField, equals: .title)
                    
                    TextField("Description (Optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                        .focused($focusedField, equals: .description)
                }
                
                Section {
                    DatePicker("Target Date", selection: $deadline, displayedComponents: .date)
                    
                    Toggle("Hard Deadline", isOn: $isHardDeadline)
                        .tint(Color(hex: "256142"))
                    
                    if isHardDeadline {
                        Text("Note: Date cannot be changed after saving")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(FairwayButtonStyle(isDestructive: true))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let goal = Goal(
                            title: title,
                            description: description,
                            deadlineDate: deadline,
                            isHardDeadline: isHardDeadline
                        )
                        viewModel.addGoal(goal)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .buttonStyle(FairwayButtonStyle())
                }
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                    }
                    .buttonStyle(FairwayButtonStyle())
                }
            }
        }
    }
}

#Preview {
    AddGoalView(viewModel: GoalsViewModel())
} 