//
//  ProgressBar.swift
//  financialGoal
//
//  Created by basant amin bakir on 06/10/2024.
//

import SwiftUI


    struct ProgressBar: View {
        @Binding var progress: Float
//        @Binding var showPopup: Bool // التحكم في إظهار النافذة المنبثقة
        var color = Color.purple

        var body: some View {
            ZStack {
//                Button(action: {
//                    showPopup = true // إظهار النافذة المنبثقة عند الضغط
//                }) {
//                    Image(systemName: "plus")
//                        .foregroundColor(Color.black)
//                        .font(.system(size: 40))
//                }

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
#Preview {
    ContentView()
}
