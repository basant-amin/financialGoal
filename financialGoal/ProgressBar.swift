//
//  ProgressBar.swift
//  financialGoal
//
//  Created by basant amin bakir on 06/10/2024.
//

import SwiftUI


    struct ProgressBar: View {
        @Binding var progress: Float
        @Binding var showPopup: Bool
        @Binding var selectedEmoji: String
        @Binding var showEmojiPicker: Bool
        
        var color = Color.purple

        var body: some View {
            ZStack {


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
                
                // Show emoji or button
                if selectedEmoji.isEmpty {
                    Button(action: {
                        showEmojiPicker.toggle()
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .frame(width: 60, height: 60) // Size of the button
                    .background(Color.white.opacity(0.8)) // Background behind the button
                    .clipShape(Circle())
                    .shadow(radius: 5)
                } else {
                    Text(selectedEmoji)
                        .font(.system(size: 70))
                }
            }
        }
    }
#Preview {
    ContentView()
}
