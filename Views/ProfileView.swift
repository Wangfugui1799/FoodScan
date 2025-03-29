//
//  ProfileView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

struct UserProfile: Identifiable {
    var id = UUID()
    var name: String
    var age: Int
    var gender: String
    var weight: Double
    var height: Double
    var activityLevel: String
    
    // 示例数据
    static var example = UserProfile(
        name: "用户",
        age: 28,
        gender: "男",
        weight: 70.0,
        height: 175.0,
        activityLevel: "中等活跃"
    )
}

struct ProfileView: View {
    @State private var userProfile = UserProfile.example
    @State private var nutritionGoal = NutritionGoal()
    @State private var isEditingProfile = false
    @State private var isEditingGoals = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 用户头像和名称
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                        
                        Text(userProfile.name)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .padding()
                    
                    // 个人信息卡片
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("个人信息")
                                .font(.system(size: 18, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingProfile = true
                            }) {
                                Text("编辑")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Divider()
                        
                        ProfileInfoRow(title: "年龄", value: "\(userProfile.age)岁")
                        ProfileInfoRow(title: "性别", value: userProfile.gender)
                        ProfileInfoRow(title: "体重", value: "\(String(format: "%.1f", userProfile.weight))kg")
                        ProfileInfoRow(title: "身高", value: "\(String(format: "%.1f", userProfile.height))cm")
                        ProfileInfoRow(title: "活动水平", value: userProfile.activityLevel)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // 营养目标卡片
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("营养目标")
                                .font(.system(size: 18, weight: .bold))
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingGoals = true
                            }) {
                                Text("编辑")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Divider()
                        
                        ProfileInfoRow(title: "卡路里", value: "\(nutritionGoal.caloriesGoal) kcal/天")
                        ProfileInfoRow(title: "蛋白质", value: "\(String(format: "%.1f", nutritionGoal.proteinGoal))g/天")
                        ProfileInfoRow(title: "脂肪", value: "\(String(format: "%.1f", nutritionGoal.fatGoal))g/天")
                        ProfileInfoRow(title: "碳水化合物", value: "\(String(format: "%.1f", nutritionGoal.carbsGoal))g/天")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // 其他设置选项
                    VStack(alignment: .leading, spacing: 15) {
                        Text("设置")
                            .font(.system(size: 18, weight: .bold))
                        
                        Divider()
                        
                        SettingRow(icon: "bell.fill", title: "通知设置")
                        SettingRow(icon: "lock.fill", title: "隐私设置")
                        SettingRow(icon: "questionmark.circle.fill", title: "帮助与反馈")
                        SettingRow(icon: "info.circle.fill", title: "关于我们")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 80)
                }
                .padding(.vertical)
            }
            .background(Color.gray.opacity(0.05))
            .navigationTitle("个人中心")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView(userProfile: $userProfile)
            }
            .sheet(isPresented: $isEditingGoals) {
                EditNutritionGoalsView(nutritionGoal: $nutritionGoal)
            }
        }
    }
}

struct ProfileInfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16))
        }
    }
}

struct SettingRow: View {
    var icon: String
    var title: String
    
    var body: some View {
        Button(action: {
            // 设置项点击操作
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.green)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .foregroundColor(.primary)
    }
}

// EditProfileView已在EditProfileView.swift文件中定义