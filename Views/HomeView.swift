//
//  HomeView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var nutritionRecord = DailyNutritionRecord.example
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 今日营养摄入环形进度条
                    VStack(spacing: 10) {
                        Text("今日营养")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        NutritionCircleView(
                            progress: nutritionRecord.caloriesProgress,
                            currentCalories: nutritionRecord.totalCalories,
                            goalCalories: nutritionRecord.nutritionGoal.caloriesGoal
                        )
                        .padding()
                    }
                    
                    // 营养素分布卡片
                    VStack(spacing: 15) {
                        HStack(spacing: 0) {
                            // 蛋白质
                            NutrientCardView(
                                title: "蛋白质",
                                value: Int(nutritionRecord.totalProtein),
                                unit: "g"
                            )
                            
                            Divider()
                                .frame(height: 40)
                            
                            // 脂肪
                            NutrientCardView(
                                title: "脂肪",
                                value: Int(nutritionRecord.totalFat),
                                unit: "g"
                            )
                            
                            Divider()
                                .frame(height: 40)
                            
                            // 碳水
                            NutrientCardView(
                                title: "碳水",
                                value: Int(nutritionRecord.totalCarbs),
                                unit: "g"
                            )
                        }
                        .frame(height: 80)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    
                    // 今日饮食记录
                    VStack(spacing: 15) {
                        HStack {
                            Text("今日饮食")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            NavigationLink(destination: Text("查看全部饮食记录")) {
                                Text("查看全部")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.horizontal)
                        
                        if nutritionRecord.consumedFoods.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("今天还没有记录饮食")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                Button(action: {
                                    // 跳转到拍照识别页面
                                }) {
                                    Text("立即添加")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(Color.green)
                                        .cornerRadius(20)
                                }
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        } else {
                            ForEach(nutritionRecord.consumedFoods) { food in
                                FoodRecordRow(food: food)
                            }
                        }
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.05))
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

// 营养素卡片视图
struct NutrientCardView: View {
    var title: String
    var value: Int
    var unit: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Text("\(value)\(unit)")
                .font(.system(size: 24, weight: .bold))
        }
        .frame(maxWidth: .infinity)
    }
}

// 食物记录行视图
struct FoodRecordRow: View {
    var food: Food
    
    var body: some View {
        HStack {
            // 食物图片
            ZStack {
                if let image = food.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        )
                }
            }
            
            // 食物信息
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.system(size: 16, weight: .medium))
                
                Text("\(food.calories) kcal")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 时间
            Text(formatTime(food.consumptionTime))
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 格式化时间为小时:分钟
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    HomeView()
}