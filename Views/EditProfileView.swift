//
//  EditProfileView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var userProfile: UserProfile
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var age: String
    @State private var gender: String
    @State private var weight: String
    @State private var height: String
    @State private var activityLevel: String
    
    let genderOptions = ["男", "女", "其他"]
    let activityLevelOptions = ["久坐不动", "轻度活跃", "中等活跃", "非常活跃", "极度活跃"]
    
    init(userProfile: Binding<UserProfile>) {
        self._userProfile = userProfile
        _name = State(initialValue: userProfile.wrappedValue.name)
        _age = State(initialValue: String(userProfile.wrappedValue.age))
        _gender = State(initialValue: userProfile.wrappedValue.gender)
        _weight = State(initialValue: String(format: "%.1f", userProfile.wrappedValue.weight))
        _height = State(initialValue: String(format: "%.1f", userProfile.wrappedValue.height))
        _activityLevel = State(initialValue: userProfile.wrappedValue.activityLevel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("姓名", text: $name)
                    TextField("年龄", text: $age)
                        .keyboardType(.numberPad)
                    
                    Picker("性别", selection: $gender) {
                        ForEach(genderOptions, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("身体数据")) {
                    TextField("体重 (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    TextField("身高 (cm)", text: $height)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("活动水平")) {
                    Picker("活动水平", selection: $activityLevel) {
                        ForEach(activityLevelOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("编辑个人信息")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveProfile()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveProfile() {
        userProfile.name = name
        userProfile.age = Int(age) ?? userProfile.age
        userProfile.gender = gender
        userProfile.weight = Double(weight) ?? userProfile.weight
        userProfile.height = Double(height) ?? userProfile.height
        userProfile.activityLevel = activityLevel
    }
}

struct EditNutritionGoalsView: View {
    @Binding var nutritionGoal: NutritionGoal
    @Environment(\.presentationMode) var presentationMode
    
    @State private var calories: String
    @State private var protein: String
    @State private var fat: String
    @State private var carbs: String
    
    init(nutritionGoal: Binding<NutritionGoal>) {
        self._nutritionGoal = nutritionGoal
        _calories = State(initialValue: String(nutritionGoal.wrappedValue.caloriesGoal))
        _protein = State(initialValue: String(format: "%.1f", nutritionGoal.wrappedValue.proteinGoal))
        _fat = State(initialValue: String(format: "%.1f", nutritionGoal.wrappedValue.fatGoal))
        _carbs = State(initialValue: String(format: "%.1f", nutritionGoal.wrappedValue.carbsGoal))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("每日营养目标")) {
                    HStack {
                        Text("卡路里")
                        Spacer()
                        TextField("卡路里", text: $calories)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                        Text("kcal")
                    }
                    
                    HStack {
                        Text("蛋白质")
                        Spacer()
                        TextField("蛋白质", text: $protein)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                    }
                    
                    HStack {
                        Text("脂肪")
                        Spacer()
                        TextField("脂肪", text: $fat)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                    }
                    
                    HStack {
                        Text("碳水化合物")
                        Spacer()
                        TextField("碳水化合物", text: $carbs)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        Text("g")
                    }
                }
                
                Section {
                    Button("根据个人信息计算推荐值") {
                        // 这里可以添加根据用户信息计算推荐营养摄入量的逻辑
                    }
                    .foregroundColor(.green)
                }
            }
            .navigationTitle("编辑营养目标")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveNutritionGoals()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveNutritionGoals() {
        nutritionGoal.caloriesGoal = Int(calories) ?? nutritionGoal.caloriesGoal
        nutritionGoal.proteinGoal = Double(protein) ?? nutritionGoal.proteinGoal
        nutritionGoal.fatGoal = Double(fat) ?? nutritionGoal.fatGoal
        nutritionGoal.carbsGoal = Double(carbs) ?? nutritionGoal.carbsGoal
    }
}

#Preview {
    EditProfileView(userProfile: .constant(UserProfile.example))
}