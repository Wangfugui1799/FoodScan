//
//  FoodModel.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import Foundation
import SwiftUI

// 食物模型
struct Food: Identifiable {
    var id = UUID()
    var name: String            // 食物名称
    var image: UIImage?         // 食物图片
    var calories: Int           // 卡路里
    var protein: Double         // 蛋白质(g)
    var fat: Double             // 脂肪(g)
    var carbs: Double           // 碳水化合物(g)
    var consumptionTime: Date   // 食用时间
    
    // 创建示例数据
    static var example: Food {
        Food(
            name: "鸡胸肉沙拉",
            image: nil,
            calories: 320,
            protein: 28.0,
            fat: 12.0,
            carbs: 25.0,
            consumptionTime: Date()
        )
    }
}

// 用户每日营养摄入目标
struct NutritionGoal {
    var caloriesGoal: Int = 2000    // 卡路里目标
    var proteinGoal: Double = 80.0   // 蛋白质目标(g)
    var fatGoal: Double = 60.0       // 脂肪目标(g)
    var carbsGoal: Double = 250.0    // 碳水化合物目标(g)
    
    // 根据用户信息计算推荐摄入量的方法可以在这里添加
    mutating func calculateGoals(age: Int, gender: String, weight: Double, height: Double, activityLevel: String) {
        // 这里可以实现基于用户信息的营养目标计算逻辑
        // 例如使用Harris-Benedict公式计算基础代谢率(BMR)，然后根据活动水平调整
    }
}

// 用户每日营养摄入记录
class DailyNutritionRecord: ObservableObject {
    @Published var date: Date = Date()
    @Published var consumedFoods: [Food] = []
    @Published var nutritionGoal = NutritionGoal()
    
    // 计算当日总卡路里摄入量
    var totalCalories: Int {
        consumedFoods.reduce(0) { $0 + $1.calories }
    }
    
    // 计算当日总蛋白质摄入量
    var totalProtein: Double {
        consumedFoods.reduce(0) { $0 + $1.protein }
    }
    
    // 计算当日总脂肪摄入量
    var totalFat: Double {
        consumedFoods.reduce(0) { $0 + $1.fat }
    }
    
    // 计算当日总碳水化合物摄入量
    var totalCarbs: Double {
        consumedFoods.reduce(0) { $0 + $1.carbs }
    }
    
    // 计算卡路里摄入进度
    var caloriesProgress: Double {
        Double(totalCalories) / Double(nutritionGoal.caloriesGoal)
    }
    
    // 添加食物到当日记录
    func addFood(_ food: Food) {
        consumedFoods.append(food)
    }
    
    // 创建示例数据
    static var example: DailyNutritionRecord {
        let record = DailyNutritionRecord()
        record.consumedFoods = [Food.example]
        return record
    }
}