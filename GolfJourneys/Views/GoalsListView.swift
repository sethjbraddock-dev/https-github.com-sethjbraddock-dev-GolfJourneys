import SwiftUI

struct GoalsListView: View {
    @ObservedObject var viewModel: GoalsViewModel
    @ObservedObject var userSettings: UserSettings
    @State private var showingAddGoal = false
    @State private var showingSettings = false
    @State private var currentQuote: GolfQuote = golfQuotes.randomElement()!
    @Environment(\.colorScheme) var colorScheme
    
    private var groupedGoals: (urgent: [Goal], other: [Goal]) {
        let sorted = viewModel.goals.sorted { $0.deadlineDate < $1.deadlineDate }
        return Dictionary(grouping: sorted) { goal in
            goal.daysRemaining <= 30 && !goal.isCompleted
        }.reduce(into: (urgent: [], other: [])) { result, group in
            if group.key {
                result.urgent = group.value
            } else {
                result.other = group.value
            }
        }
    }
    
    private var progress: Double {
        guard !viewModel.goals.isEmpty else { return 0 }
        return Double(viewModel.goals.filter(\.isCompleted).count) / Double(viewModel.goals.count)
    }
    
    private var progressText: String {
        let completed = viewModel.goals.filter(\.isCompleted).count
        let total = viewModel.goals.count
        return "\(completed) of \(total) goals completed"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome, \(userSettings.firstName)!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "256142"))
                            .listRowInsets(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\"\(currentQuote.text)\"")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("- \(currentQuote.author)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.top, 2)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                    }
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 20)
                    .onAppear {
                        currentQuote = golfQuotes.randomElement()!
                    }
                    
                    if viewModel.goals.isEmpty {
                        ContentUnavailableView {
                            Label(
                                title: { Text("No Goals Yet") },
                                icon: {
                                    Image("bunker-icon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                            )
                        } description: {
                            VStack(spacing: 16) {
                                Text("You've found the bunker! Pick it clean by creating your first goal of your golf journey.")
                                
                                Button {
                                    showingAddGoal = true
                                } label: {
                                    Text("Add goal")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color(hex: "256142"))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    } else {
                        VStack(spacing: 8) {
                            GolfBallProgressView(
                                totalGoals: viewModel.goals.count,
                                completedGoals: viewModel.goals.filter(\.isCompleted).count,
                                userName: userSettings.firstName
                            )
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())
                        .padding(.vertical, 20)
                        
                        Text("Upcoming Golf Goals")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(hex: "256142"))
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 20)
                        
                        if !groupedGoals.urgent.isEmpty {
                            Section {
                                ForEach(groupedGoals.urgent) { goal in
                                    GoalRowView(
                                        goal: goal,
                                        onComplete: {
                                            viewModel.toggleGoalCompletion(goal.id)
                                        },
                                        viewModel: viewModel
                                    )
                                }
                            } header: {
                                HStack {
                                    Image(systemName: "exclamationmark.circle.fill")
                                    Text("Due Soon")
                                }
                                .foregroundStyle(Color(hex: "256142"))
                                .font(.headline)
                            }
                        }
                        
                        Section {
                            ForEach(groupedGoals.other) { goal in
                                GoalRowView(
                                    goal: goal,
                                    onComplete: {
                                        viewModel.toggleGoalCompletion(goal.id)
                                    },
                                    viewModel: viewModel
                                )
                            }
                        } header: {
                            Text("All Goals")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Golf Goals")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddGoal = true
                    } label: {
                        Image(colorScheme == .dark ? "addgoal-icon-white" : "addgoal-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 4)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(colorScheme == .dark ? "settings-icon-white" : "settings-icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 4)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(userSettings: userSettings)
            }
        }
        .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
    }
}
