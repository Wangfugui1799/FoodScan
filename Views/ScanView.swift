//
//  ScanView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

struct ScanView: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage? = nil
    @State private var isAnalyzing = false
    @State private var recognizedFood: Food? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = capturedImage {
                    // 显示拍摄的图片
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                        .padding()
                    
                    if isAnalyzing {
                        // 分析中的加载状态
                        ProgressView("正在分析食物...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else if let food = recognizedFood {
                        // 显示识别结果
                        FoodAnalysisResultView(food: food)
                    } else {
                        // 分析按钮
                        Button(action: {
                            analyzeFood()
                        }) {
                            Text("开始分析")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        // 重新拍摄按钮
                        Button(action: {
                            capturedImage = nil
                            recognizedFood = nil
                        }) {
                            Text("重新拍摄")
                                .font(.headline)
                                .foregroundColor(.green)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // 拍照引导区域
                    VStack(spacing: 20) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("拍摄食物照片以识别营养成分")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Text("将食物放在平整表面，确保光线充足")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                    
                    // 拍照按钮
                    Button(action: {
                        showCamera = true
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("拍照识别")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("食物识别")
            .sheet(isPresented: $showCamera) {
                CameraView(capturedImage: $capturedImage, isPresented: $showCamera)
            }
        }
    }
    
    // 分析食物的方法
    private func analyzeFood() {
        isAnalyzing = true
        
        // 模拟API调用延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // 这里应该调用豆包Vision和DeepSeek V3 API进行食物识别和营养分析
            // 目前使用示例数据模拟结果
            recognizedFood = Food.example
            isAnalyzing = false
        }
    }
}

// 相机视图
struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

// 食物分析结果视图
struct FoodAnalysisResultView: View {
    var food: Food
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 食物名称
            Text(food.name)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            // 卡路里信息
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(food.calories) 卡路里")
                    .font(.headline)
            }
            .padding(.horizontal)
            
            // 营养素信息卡片
            VStack(spacing: 15) {
                Text("营养成分")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // 蛋白质进度条
                NutrientProgressView(
                    label: "蛋白质",
                    value: food.protein,
                    unit: "g",
                    color: .blue
                )
                
                // 脂肪进度条
                NutrientProgressView(
                    label: "脂肪",
                    value: food.fat,
                    unit: "g",
                    color: .orange
                )
                
                // 碳水进度条
                NutrientProgressView(
                    label: "碳水化合物",
                    value: food.carbs,
                    unit: "g",
                    color: .green
                )
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            
            // 添加到今日记录按钮
            Button(action: {
                // 添加到今日饮食记录的逻辑
            }) {
                Text("添加到今日记录")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
    }
}

// 营养素进度条视图
struct NutrientProgressView: View {
    var label: String
    var value: Double
    var unit: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                
                Spacer()
                
                Text("\(Int(value))\(unit)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.1)
                        .foregroundColor(color)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(value) / 100.0 * geometry.size.width, geometry.size.width), height: 8)
                        .foregroundColor(color)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    ScanView()
}