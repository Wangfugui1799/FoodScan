//
//  RecommendView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

struct FoodRecommendation: Identifiable {
    var id = UUID()
    var name: String
    var image: UIImage?
    var calories: Int
    var protein: Double
    var fat: Double
    var carbs: Double
    var description: String
    var tags: [String]
    
    // 示例数据
    static var examples: [FoodRecommendation] = [
        FoodRecommendation(
            name: "希腊酸奶配蓝莓",
            image: nil,
            calories: 180,
            protein: 15.0,
            fat: 5.0,
            carbs: 20.0,
            description: "高蛋白低脂肪的健康早餐选择，富含抗氧化物质。",
            tags: ["早餐", "高蛋白", "低脂"]
        ),
        FoodRecommendation(
            name: "三文鱼牛油果沙拉",
            image: nil,
            calories: 350,
            protein: 22.0,
            fat: 25.0,
            carbs: 10.0,
            description: "富含omega-3脂肪酸和健康脂肪，适合午餐或晚餐。",
            tags: ["午餐", "晚餐", "高蛋白", "健康脂肪"]
        ),
        FoodRecommendation(
            name: "藜麦蔬菜碗",
            image: nil,
            calories: 280,
            protein: 10.0,
            fat: 8.0,
            carbs: 45.0,
            description: "全谷物搭配多种蔬菜，提供丰富的膳食纤维和维生素。",
            tags: ["午餐", "素食", "高纤维"]
        ),
        FoodRecommendation(
            name: "烤鸡胸肉配烤蔬菜",
            image: nil,
            calories: 320,
            protein: 35.0,
            fat: 10.0,
            carbs: 15.0,
            description: "高蛋白低碳水的健康选择，适合增肌减脂。",
            tags: ["晚餐", "高蛋白", "低碳水"]
        ),
        FoodRecommendation(
            name: "水果坚果能量棒",
            image: nil,
            calories: 220,
            protein: 8.0,
            fat: 12.0,
            carbs: 25.0,
            description: "便携的健康零食，提供持久能量。",
            tags: ["零食", "能量补充"]
        )
    ]
}

struct RecommendView: View {
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    
    // 所有可用的食物分类
    let categories = ["早餐", "午餐", "晚餐", "零食", "高蛋白", "低脂", "低碳水", "素食"]
    
    // 根据搜索文本和选择的分类过滤推荐
    var filteredRecommendations: [FoodRecommendation] {
        var recommendations = FoodRecommendation.examples
        
        // 应用搜索过滤
        if !searchText.isEmpty {
            recommendations = recommendations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // 应用分类过滤
        if let category = selectedCategory {
            recommendations = recommendations.filter { $0.tags.contains(category) }
        }
        
        return recommendations
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top)
                
                // 分类选择器
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            CategoryButton(
                                title: category,
                                isSelected: category == selectedCategory,
                                action: {
                                    if selectedCategory == category {
                                        selectedCategory = nil
                                    } else {
                                        selectedCategory = category
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                // 推荐列表
                if filteredRecommendations.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("没有找到匹配的食物推荐")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.05))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(filteredRecommendations) { recommendation in
                                FoodRecommendationCard(recommendation: recommendation)
                            }
                        }
                        .padding()
                    }
                    .background(Color.gray.opacity(0.05))
                }
            }
            .navigationTitle("推荐食谱")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// 搜索栏组件
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("搜索食物...", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// 分类按钮组件
struct CategoryButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? Color.green : Color.white)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

// 食物推荐卡片组件
struct FoodRecommendationCard: View {
    var recommendation: FoodRecommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 食物图片
            ZStack {
                if let image = recommendation.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                }
            }
            .cornerRadius(12)
            
            // 食物名称
            Text(recommendation.name)
                .font(.system(size: 18, weight: .bold))
            
            // 食物描述
            Text(recommendation.description)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .lineLimit(2)
            
            // 营养信息
            HStack(spacing: 15) {
                NutrientInfoView(title: "卡路里", value: "\(recommendation.calories) kcal")
                NutrientInfoView(title: "蛋白质", value: "\(String(format: "%.1f", recommendation.protein))g")
                NutrientInfoView(title: "脂肪", value: "\(String(format: "%.1f", recommendation.fat))g")
                NutrientInfoView(title: "碳水", value: "\(String(format: "%.1f", recommendation.carbs))g")
            }
            
            // 标签
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(recommendation.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 12))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(15)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// 营养素信息视图
struct NutrientInfoView: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
        }
    }
}

struct RecommendView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendView()
    }
}