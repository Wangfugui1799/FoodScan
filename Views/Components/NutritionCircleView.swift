//
//  NutritionCircleView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

struct NutritionCircleView: View {
    var progress: Double
    var currentCalories: Int
    var goalCalories: Int
    
    var body: some View {
        ZStack {
            // 背景圆环
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 15)
            
            // 进度圆环
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(Color.green, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // 中心文字
            VStack(spacing: 5) {
                Text("\(currentCalories)")
                    .font(.system(size: 36, weight: .bold))
                
                Text("/\(goalCalories) kcal")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    NutritionCircleView(progress: 0.62, currentCalories: 1240, goalCalories: 2000)
}