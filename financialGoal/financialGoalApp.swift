//
//  financialGoalApp.swift
//  financialGoal
//
//  Created by basant amin bakir on 30/09/2024.
//

import SwiftUI
import SwiftData

@main
struct financialGoalApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .modelContainer(for: FinancialData.self)
        }
    }
}
