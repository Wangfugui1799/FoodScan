//
//  FoodRecognitionService.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import Foundation
import UIKit
import Combine

// 食物识别服务类
class FoodRecognitionService {
    // 单例模式
    static let shared = FoodRecognitionService()
    
    private init() {}
    
    // 识别食物的方法
    func recognizeFood(image: UIImage) -> AnyPublisher<Food, Error> {
        // 创建一个Future发布者，用于异步返回识别结果
        return Future<Food, Error> { promise in
            // 这里应该调用豆包Vision API进行食物识别
            // 然后调用DeepSeek V3 API获取营养数据
            // 目前使用模拟数据
            
            // 模拟网络延迟
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // 返回模拟数据
                let food = Food(
                    name: "鸡胸肉沙拉",
                    image: image,
                    calories: 320,
                    protein: 28.0,
                    fat: 12.0,
                    carbs: 25.0,
                    consumptionTime: Date()
                )
                
                // 成功返回食物数据
                promise(.success(food))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // 获取食物营养信息的方法
    func getNutritionInfo(foodName: String) -> AnyPublisher<Food, Error> {
        // 创建一个Future发布者，用于异步返回营养信息
        return Future<Food, Error> { promise in
            // 这里应该调用DeepSeek V3 API获取营养数据
            // 目前使用模拟数据
            
            // 模拟网络延迟
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                // 根据食物名称返回不同的模拟数据
                var food: Food
                
                switch foodName.lowercased() {
                case "鸡胸肉沙拉":
                    food = Food(
                        name: "鸡胸肉沙拉",
                        image: nil,
                        calories: 320,
                        protein: 28.0,
                        fat: 12.0,
                        carbs: 25.0,
                        consumptionTime: Date()
                    )
                case "希腊酸奶":
                    food = Food(
                        name: "希腊酸奶配蓝莓",
                        image: nil,
                        calories: 180,
                        protein: 15.0,
                        fat: 5.0,
                        carbs: 20.0,
                        consumptionTime: Date()
                    )
                default:
                    food = Food(
                        name: foodName,
                        image: nil,
                        calories: 250,
                        protein: 10.0,
                        fat: 8.0,
                        carbs: 30.0,
                        consumptionTime: Date()
                    )
                }
                
                // 成功返回食物数据
                promise(.success(food))
            }
        }
        .eraseToAnyPublisher()
    }
}