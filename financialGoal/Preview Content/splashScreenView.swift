//
//  splashScreenView.swift
//  financialGoal
//
//  Created by basant amin bakir on 30/09/2024.
//

import SwiftUI

struct splashScreenView: View {
    @State private var viewContent = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        
        if viewContent {
            ContentView()
        }else{
            
            VStack {
                VStack{
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                    Text("Financial Goal")
                        .font(.system(size: 26))
                        .foregroundColor(.black.opacity(0.80))
                    
                         
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+2.0){
                    
                    withAnimation{
                        self.viewContent = true
                    }
                  
                }
            
        }
        
        
        
  
        }
    }
}


#Preview {
    splashScreenView()
}
