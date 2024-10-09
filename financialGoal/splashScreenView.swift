//
//  splashScreenView.swift
//  financialGoal
//
//  Created by basant amin bakir on 30/09/2024.
//
import SwiftUI

struct SplashScreenView: View {
    @State private var viewContent = false
    @State private var size: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0.0
    
    var body: some View {
        if viewContent {
            ContentView()
        } else {
            VStack {
                Image("IOSlogo") // Replace with your image name
                    .resizable()
                    .aspectRatio(contentMode: .fit) // Adjusts the image size to fit
                    .frame(width: 250, height: 250) // Set the size of the image
                    .scaleEffect(size)
                    .opacity(opacity)
                    .rotationEffect(.degrees(rotation)) // Add rotation effect
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                            self.size = 1.0 // Scale to original size
                            self.opacity = 1.0 // Fade in
                            self.rotation = 360 // Full rotation
                        }

                        // Adding a scale down effect before scaling up
                        withAnimation(.easeOut(duration: 0.5)) {
                            self.size = 0.5 // Scale down initially
                        }

                        // Then scale back up
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                                self.size = 1.0 // Scale back to original size
                                self.opacity = 1.0 // Fade in
                                self.rotation = 360 // Full rotation
                            }
                        }

                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        self.viewContent = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
