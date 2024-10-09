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
    @State var goalCompleted = false
    @State private var showDeleteAlert = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showEmojiPicker = false
    @State private var selectedEmoji: String = ""
    
    
    

    var body: some View {
        NavigationStack {
            ZStack {
                Image("B4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 600.0, height: 1000)
                    .ignoresSafeArea()

                Image("Card")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 750, height:750)
                    .padding(.top, 90)

                VStack {
                    
                    
                 
                    ProgressBar(progress: self.$progressValue, showPopup: $showPopup, selectedEmoji: $selectedEmoji, showEmojiPicker: $showEmojiPicker)
                        .frame(width: 160.0, height: 160.0)
                        .padding(20.0)

                    Text("Goal: \(Int(goalAmount))")
                        .padding(.top, 30)
                    Text("Current: \(Int(totalAmount))")

                    if goalAmount == 0 {
                        TextField("Enter new goal", text: $goalInput)
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal, 210)
                            .padding(.top, 40)

                        Button(action: {
                            if let newGoal = Float(goalInput), newGoal > 0 {
                                goalAmount = newGoal
                                progressValue = totalAmount / goalAmount
                                goalInput = ""
                                showPopup = false

                                let newFinancialData = FinancialData(progress: progressValue, goalAmount: goalAmount, addAmount: totalAmount, selectedEmoji: selectedEmoji)
                                modelContext.insert(newFinancialData)

                                do {
                                    try modelContext.save()
                                } catch {
                                    print("Error saving new financial data: \(error)")
                                }

                                // Dismiss the keyboard after saving goal
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue1)
                                .cornerRadius(20)
                        }
                        .padding(.horizontal, 270)
                        .padding(.top, 30)
                    }

                    if goalAmount > 0 {
                        TextField("Enter amount 💰", text: $addAmount)
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.horizontal, 210)
                            .padding(.top, 40)

                        Button(action: {
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
                                    financialData.selectedEmoji = selectedEmoji

                                    do {
                                        try modelContext.save()
                                    } catch {
                                        print("Error saving financial data: \(error)")
                                    }
                                }

                                // Dismiss the keyboard after adding amount
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }) {
                            Text("Add Amount")
                                .foregroundColor(.white)
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue1)
                                .cornerRadius(20)
                        }
                        .padding(.horizontal, 270)
                        .padding(.top, 30)
                    }

                    if showEmojiPicker {
                        EmojiView(show: $showEmojiPicker, selectedEmoji: $selectedEmoji)
                            .transition(.move(edge: .bottom))
                    }

                    NavigationLink(destination: CelebrationView(goalCompleted: $goalCompleted, resetAction: resetData), isActive: $goalCompleted) {
                        EmptyView()
                    }
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading) {
                        Text("Welcome to your")
                        
                            .padding(.top, showEmojiPicker  ? 0 : 20)
                        Text("Financial Goal")
                            .font(.system(size: 35))
                            .foregroundColor(.lightBlack)
                            .bold()
                            .padding(.bottom, showEmojiPicker  ? 400 : 0)
                    }
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
                    selectedEmoji = financialData.selectedEmoji ?? ""
                }
            }
        }
    }

    private func resetData() {
        goalAmount = 0.0
        totalAmount = 0.0
        progressValue = 0.0
        addAmount = ""
        selectedEmoji = ""

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
