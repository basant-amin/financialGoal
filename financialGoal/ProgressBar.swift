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

    var color = Color.blue1

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white) // Change Circle color to white
                .frame(width: 220, height: 220) // Set Circle size to 220x220
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Add shadow
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(Color(red: 99/255, green: 94/255, blue: 94/255)) // Plus button color
                        .font(.system(size: 90)) // Adjust the plus button size
                )
            
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.20)
                .foregroundColor(Color.gray.opacity(0.5)) // Circle border color

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [Color.lightBlue, Color.blue1]
                        ),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: progress)

            // Show emoji or button
            if selectedEmoji.isEmpty {
                Button(action: {
                    withAnimation {
                        showEmojiPicker.toggle()
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 72))
                        .foregroundColor(.black)
                }
            } else {
                Text(selectedEmoji)
                    .font(.system(size: 100))
            }

        }
    }
}

#Preview {
    ContentView()
}
