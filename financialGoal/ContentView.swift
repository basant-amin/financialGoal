//
//  ContentView.swift
//  financialGoal
//
//  Created by basant amin bakir on 30/09/2024.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var financialDataList: [FinancialData]
    @State var progressValue: Float = 0.0
    @State var totalAmount: Float = 0.0
    @State var goalAmount: Float = 0.0
    @State var addAmount: String = ""
    @State var showPopup = false
    @State private var goalInput: String = ""
    @State var goalCompleted = false // State to track if goal is completed
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    ProgressBar(progress: self.$progressValue)
                        .frame(width: 160.0, height: 160.0)
                        .padding(20.0)

                    Text("Goal: \(Int(goalAmount))")
                    Text("Current: \(Int(totalAmount))")

                    if goalAmount == 0 {
                        TextField("Enter new goal", text: $goalInput)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal, 30)

                        Button("Save") {
                            if let newGoal = Float(goalInput), newGoal > 0 {
                                goalAmount = newGoal
                                progressValue = totalAmount / goalAmount
                                goalInput = ""
                                showPopup = false

                                let newFinancialData = FinancialData(progress: progressValue, goalAmount: goalAmount, addAmount: totalAmount)
                                modelContext.insert(newFinancialData)

                                do {
                                    try modelContext.save()
                                } catch {
                                    print("Error saving new financial data: \(error)")
                                }
                            }
                        }
                    }

                    if goalAmount > 0 {
                        TextField("Enter amount", text: $addAmount)
                            .keyboardType(.decimalPad)
                            .padding()
                            .border(Color.gray, width: 1)
                            .padding(.horizontal)

                        Button("Add Amount") {
                            if let amount = Float(self.addAmount), amount > 0 {
                                totalAmount += amount

                                if totalAmount >= goalAmount {
                                    totalAmount = goalAmount
                                    progressValue = 1.0
                                    goalCompleted = true
                                } else {
                                    progressValue = totalAmount / goalAmount
                                }
                                addAmount = ""

                                if let financialData = financialDataList.first {
                                    financialData.addAmount = totalAmount

                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print("Error saving financial data: \(error)")
                                    }
                                }
                            }
                        }
                        .padding()
                    }

                    NavigationLink(destination: CelebrationView(goalCompleted: $goalCompleted, resetAction: resetData), isActive: $goalCompleted) {
                        EmptyView()
                    }

                    Spacer()
                }

                if showPopup {
                    VStack(spacing: 20) {
                        Text("Set Your Goal")
                            .font(.headline)
                            .padding(.top)
                    }
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.933, green: 0.933, blue: 0.933), lineWidth: 1)
                    )
                    .overlay(
                        Button(action: {
                            showPopup = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding()
                        }, alignment: .topTrailing
                    )
                    .padding()
                }
            }
            .navigationTitle("Financial Goal")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Welcome to your")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color.red)
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Goal"),
                    message: Text("Are you sure you want to delete this goal?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let financialData = financialDataList.first {
                            modelContext.delete(financialData)
                            resetData()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                if let financialData = financialDataList.first {
                    goalAmount = financialData.goalAmount
                    totalAmount = financialData.addAmount
                    progressValue = totalAmount / goalAmount
                }
            }
        }
    }

    private func resetData() {
        goalAmount = 0.0
        totalAmount = 0.0
        progressValue = 0.0
        addAmount = ""

        if let financialData = financialDataList.first {
            modelContext.delete(financialData)
            do {
                try modelContext.save()
            } catch {
                print("Error saving changes after resetting: \(error)")
            }
        }
    }
}
#Preview {
    ContentView()
}
