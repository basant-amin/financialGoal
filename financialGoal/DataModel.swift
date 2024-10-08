//
//  DataModel.swift
//  financialGoal
//
//  Created by basant amin bakir on 06/10/2024.
//


import Foundation
import SwiftData

@Model
class FinancialData: Identifiable {
    var id: UUID = UUID() // معرف فريد لكل بيانات مالية
    var progress: Float
    var goalAmount: Float
    var addAmount: Float
    var selectedEmoji: String?
    
    init(progress: Float = 0.0, goalAmount: Float = 0.0, addAmount: Float = 0.0, selectedEmoji: String? = nil) {
        // إنشاء معرف فريد جديد
        self.progress = progress
        self.goalAmount = goalAmount
        self.addAmount = addAmount
        self.selectedEmoji = selectedEmoji 
    }
}


