//
//  ContentView.swift
//  financialGoal
//
//  Created by basant amin bakir on 30/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State var progressValue: Float = 0.0
    @State var totalAmount: Float = 0.0 // المبلغ الحالي
    @State var goalAmount: Float = 0.0
    @State var emojie : String = ""// الهدف النهائي
    @State var addAmount: String = "" // المبلغ الذي سيدخله المستخدم
    @State var showPopup = false // التحكم في إظهار النافذة المنبثقة
    @State private var goalInput: String = "" // لإدخال الهدف المالي الجديد

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // محتوى التطبيق الرئيسي
                    Text("Add your Goal")
                        .font(.headline)
                        .padding(.top, 50)
                        .padding(.bottom, 10)

                    ProgressBar(progress: self.$progressValue, showPopup: $showPopup)
                        .frame(width: 160.0, height: 160.0)
                        .padding(20.0)

                    Text("Goal: \(Int(goalAmount))")
                    Text("Current: \(Int(totalAmount))")

                    // إدخال المبلغ الذي يريد المستخدم إضافته
                    TextField("Enter amount", text: $addAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .border(Color.gray, width: 1)
                        .padding(.horizontal)

                    Button("Add Amount") {
                        if let amount = Float(self.addAmount), amount > 0 {
                            totalAmount += amount

                            // حساب التقدم بناءً على النسبة بين المبلغ المدخل والهدف
                            if totalAmount >= goalAmount {
                                totalAmount = goalAmount
                                progressValue = 1.0
                            } else {
                                progressValue = totalAmount / goalAmount
                            }

                            // إعادة تعيين الحقل بعد الإدخال
                            addAmount = ""
                        }
                    }
                    .padding()

                    Spacer() // لضبط المحتوى بالأسفل
                }

                // نافذة منبثقة صغيرة في المنتصف
                if showPopup {
                    VStack(spacing: 5) {
                        Text("Set Your Goal")
                            .font(.headline)
                            .padding(.top) // إضافة padding العلوي

                        // حقل إدخال الهدف المالي الجديد مع تصميم محسّن
                        TextField("Enter new goal", text: $goalInput)
                            .keyboardType(.decimalPad)
                            .padding()  // إضافة padding داخل الحقل
                            .background(Color.white) // خلفية الحقل بيضاء
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1) // لون الحدود رمادي
                            )
                        
                            .padding(.horizontal, 30) // Padding على الأطراف لجعل الحقل بعيد عن الحواف
                        TextField("Enter Item Emoje 💰", text: $emojie)
                            .keyboardType(.decimalPad)
                            .padding()  // إضافة padding داخل الحقل
                            .background(Color.white) // خلفية الحقل بيضاء
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1) // لون الحدود رمادي
                            )
                        
                            .padding(.horizontal, 30) // Padding على ا
                        
                        Button("Save") {
                            // تعيين الهدف الجديد وإغلاق النافذة المنبثقة
                            if let newGoal = Float(goalInput), newGoal > 0 {
                                goalAmount = newGoal
                                goalInput = "" // إعادة تعيين حقل الإدخال
                                showPopup = false // إغلاق النافذة
                            }
                        }
                        .padding(.top, 10)

                    }
                    .frame(width: 300, height: 200) // حجم النافذة المنبثقة
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 0.933, green: 0.933, blue: 0.933), lineWidth: 1) // لون الحدود (#eee)
                    )
                    .overlay(
                        Button(action: {
                            showPopup = false // إغلاق النافذة عند الضغط على الزر
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding()
                        }, alignment: .topTrailing
                    )
                    .padding()  // Padding إضافي للنافذة نفسها
                }
            }
            .navigationTitle("Financial Goal")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Welcome to your")
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("function")
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color.red)
                    }
                }
            }
        }
    }

    struct ProgressBar: View {
        @Binding var progress: Float
        @Binding var showPopup: Bool // التحكم في إظهار النافذة المنبثقة
        var color = Color.purple

        var body: some View {
            ZStack {
                Button(action: {
                    showPopup = true // إظهار النافذة المنبثقة عند الضغط
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color.black)
                        .font(.system(size: 40))
                }

                Circle()
                    .stroke(lineWidth: 20.0)
                    .opacity(0.20)
                    .foregroundColor(Color.gray)
                

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 12,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.easeInOut(duration: 1.0))
            }
        }
    }
}

#Preview {
    ContentView()
}
