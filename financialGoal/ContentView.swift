//
//  ContentView.swift
//  financialGoal
//
//  Created by basant amin bakir on 30/09/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // الوصول إلى حاوية البيانات
    @Query private var financialDataList: [FinancialData] // جلب بيانات الأهداف المالية المخزنة
    
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
                    Text("Add your Goal")
                        .font(.headline)
                        .padding(.top, 50)
                        .padding(.bottom, 10)
                    
                    ProgressBar(progress: self.$progressValue, showPopup: $showPopup)
                        .frame(width: 160.0, height: 160.0)
                        .padding(20.0)

                    Text("Goal: \(Int(goalAmount))")
                    Text("Current: \(Int(totalAmount))")
                    
                    TextField("Enter amount", text: $addAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .border(Color.gray, width: 1)
                        .padding(.horizontal)
                    
                    Button("Add Amount") {
                        if let amount = Float(self.addAmount), amount > 0 {
                            totalAmount += amount
                            
                            // Check if totalAmount reaches goalAmount
                            if totalAmount >= goalAmount {
                                totalAmount = goalAmount
                                progressValue = 1.0
                                goalCompleted = true
                            } else {
                                progressValue = totalAmount / goalAmount
                            }
                            addAmount = ""
                            
                            // Update the financial data in the model
                            if let financialData = financialDataList.first {
                                financialData.addAmount = totalAmount
                                
                                // Save the changes with error handling
                                do {
                                    try modelContext.save() // Save the changes
                                } catch {
                                    print("Error saving financial data: \(error)")
                                }
                            }
                        }
                    }
                    .padding()

                    // Navigate to CelebrationView if the goal is completed
                    NavigationLink(destination: CelebrationView(), isActive: $goalCompleted) {
                        EmptyView()
                    }
                    
                    Spacer()
                }

                if showPopup {
                    VStack(spacing: 20) {
                        Text("Set Your Goal")
                            .font(.headline)
                            .padding(.top)

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
                                progressValue = totalAmount / goalAmount // Update progress based on the new goal
                                goalInput = ""
                                showPopup = false
                                
                                // Create a new FinancialData instance and save it
                                let newFinancialData = FinancialData(progress: progressValue, goalAmount: goalAmount, addAmount: totalAmount)
                                modelContext.insert(newFinancialData) // Insert the new financial data
                                
                                // Save the new financial data with error handling
                                do {
                                    try modelContext.save() // Save the new data
                                } catch {
                                    print("Error saving new financial data: \(error)")
                                }
                            }
                        }
                        .padding(.top, 10)
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
                        // Delete the financial data
                        if let financialData = financialDataList.first {
                            modelContext.delete(financialData) // Delete the first financial data
                            goalAmount = 0.0
                            totalAmount = 0.0
                            progressValue = 0.0
                            // Save the changes
                            do {
                                try modelContext.save()
                            } catch {
                                print("Error saving changes after deletion: \(error)")
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                if let financialData = financialDataList.first {
                    goalAmount = financialData.goalAmount
                    totalAmount = financialData.addAmount
                    progressValue = totalAmount / goalAmount // Initialize progress value based on stored data
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
