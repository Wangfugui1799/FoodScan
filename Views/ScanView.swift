//
//  ScanView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI
import Combine

struct ScanView: View {
    // 状态变量
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var capturedImage: UIImage? = nil
    @State private var isAnalyzing = false
    @State private var recognizedFood: Food? = nil
    @State private var showingGuide = false
    @State private var animateScanning = false
    
    // 渐变色定义
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景色
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // 顶部标题区域
                        HStack {
                            Text("食物扫描")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                showingGuide.toggle()
                            }) {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 22))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        if let image = capturedImage {
                            // 显示拍摄的图片
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                
                                if isAnalyzing {
                                    // 分析中的动画效果
                                    ZStack {
                                        Color.black.opacity(0.5)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                        
                                        VStack(spacing: 15) {
                                            LottieAnimationView()
                                                .frame(width: 100, height: 100)
                                            
                                            Text("正在分析食物...")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            if isAnalyzing {
                                // 分析中的提示文字
                                Text("AI正在识别食物并计算营养成分")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                            } else if let food = recognizedFood {
                                // 显示识别结果
                                FoodAnalysisResultView(food: food)
                            } else {
                                // 操作按钮区域
                                VStack(spacing: 15) {
                                    // 分析按钮
                                    Button(action: {
                                        withAnimation {
                                            analyzeFood()
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "wand.and.stars")
                                            Text("开始分析")
                                        }
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            gradientBackground
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
                                    }
                                    .padding(.horizontal)
                                    
                                    // 重新拍摄按钮
                                    Button(action: {
                                        withAnimation {
                                            capturedImage = nil
                                            recognizedFood = nil
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: "arrow.counterclockwise")
                                            Text("重新拍摄")
                                        }
                                        .font(.headline)
                                        .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), lineWidth: 1)
                                        )
                                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            // 拍照引导区域
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 300)
                                
                                VStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 120, height: 120)
                                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                                        
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                                    }
                                    
                                    Text("拍摄食物照片以识别营养成分")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    
                                    Text("将食物放在平整表面，确保光线充足")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.horizontal)
                            
                            // 拍照和相册按钮区域
                            VStack(spacing: 15) {
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
                                    .background(
                                        gradientBackground
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
                                }
                                .padding(.horizontal)
                                
                                // 从相册选择按钮
                                Button(action: {
                                    showPhotoLibrary = true
                                }) {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle")
                                        Text("从相册选择")
                                    }
                                    .font(.headline)
                                    .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), lineWidth: 1)
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                                }
                                .padding(.horizontal)
                            }
                            
                            // 使用说明卡片
                            VStack(alignment: .leading, spacing: 15) {
                                Text("使用说明")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0.2)))
                                            .frame(width: 40, height: 40)
                                        
                                        Text("1")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)))
                                    }
                                    
                                    Text("拍摄或选择食物照片")
                                        .font(.subheadline)
                                }
                                
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.2)))
                                            .frame(width: 40, height: 40)
                                        
                                        Text("2")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                                    }
                                    
                                    Text("AI自动识别食物并分析营养成分")
                                        .font(.subheadline)
                                }
                                
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Text("3")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Text("查看详细营养信息并记录饮食")
                                        .font(.subheadline)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
                            .padding()
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.bottom, 80) // 为底部Tab栏留出空间
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(capturedImage: $capturedImage, isPresented: $showCamera)
            }
            .sheet(isPresented: $showPhotoLibrary) {
                PhotoLibraryView(selectedImage: $capturedImage, isPresented: $showPhotoLibrary)
            }
            .sheet(isPresented: $showingGuide) {
                ScanGuideView()
            }
        }
    }
    
    // 分析食物的方法
    private func analyzeFood() {
        isAnalyzing = true
        animateScanning = true
        
        // 模拟API调用延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // 这里应该调用豆包Vision和DeepSeek V3 API进行食物识别和营养分析
            // 目前使用示例数据模拟结果
            recognizedFood = Food.example
            isAnalyzing = false
            animateScanning = false
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

// 相册视图
struct PhotoLibraryView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoLibraryView
        
        init(_ parent: PhotoLibraryView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
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
    @State private var showNutritionDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 食物名称和卡路里信息
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(food.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(food.calories) 卡路里")
                            .font(.headline)
                    }
                }
                
                Spacer()
                
                // 展开/收起详情按钮
                Button(action: {
                    withAnimation {
                        showNutritionDetails.toggle()
                    }
                }) {
                    Image(systemName: showNutritionDetails ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                }
            }
            .padding(.horizontal)
            
            // 营养素信息卡片
            VStack(spacing: 20) {
                // 营养素分布图表
                HStack(spacing: 0) {
                    // 蛋白质
                    NutrientPieSliceView(
                        value: food.protein,
                        total: food.protein + food.fat + food.carbs,
                        color: .blue,
                        icon: "p.circle.fill",
                        title: "蛋白质",
                        amount: "\(Int(food.protein))g"
                    )
                    
                    // 脂肪
                    NutrientPieSliceView(
                        value: food.fat,
                        total: food.protein + food.fat + food.carbs,
                        color: .orange,
                        icon: "f.circle.fill",
                        title: "脂肪",
                        amount: "\(Int(food.fat))g"
                    )
                    
                    // 碳水
                    NutrientPieSliceView(
                        value: food.carbs,
                        total: food.protein + food.fat + food.carbs,
                        color: .green,
                        icon: "c.circle.fill",
                        title: "碳水",
                        amount: "\(Int(food.carbs))g"
                    )
                }
                .padding(.vertical)
                
                if showNutritionDetails {
                    Divider()
                    
                    // 详细营养素进度条
                    VStack(spacing: 15) {
                        Text("详细营养成分")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
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
                }
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
            .padding(.horizontal)
            
            // 添加到今日记录按钮
            Button(action: {
                // 添加到今日饮食记录的逻辑
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("添加到今日记录")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)), Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

// 营养素饼图切片视图
struct NutrientPieSliceView: View {
    var value: Double
    var total: Double
    var color: Color
    var icon: String
    var title: String
    var amount: String
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 5)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: CGFloat(value / total))
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(amount)
                .font(.system(size: 16, weight: .bold))
        }
        .frame(maxWidth: .infinity)
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
                    // 背景条
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: geometry.size.width, height: 10)
                        .opacity(0.1)
                        .foregroundColor(color)
                    
                    // 进度条
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: min(CGFloat(value) / 100.0 * geometry.size.width, geometry.size.width), height: 10)
                        .foregroundColor(color)
                }
            }
            .frame(height: 10)
        }
    }
}

// 扫描指南视图
struct ScanGuideView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("如何获得最佳扫描效果")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    GuideItemView(
                        icon: "light.max",
                        title: "充足的光线",
                        description: "确保食物处于明亮的环境中，避免阴影遮挡"
                    )
                    
                    GuideItemView(
                        icon: "camera.viewfinder",
                        title: "正确的角度",
                        description: "从顶部或45度角拍摄，确保能看清食物的全貌"
                    )
                    
                    GuideItemView(
                        icon: "hand.draw",
                        title: "稳定拍摄",
                        description: "保持手机稳定，避免模糊不清的照片"
                    )
                    
                    GuideItemView(
                        icon: "photo.fill",
                        title: "单一食物",
                        description: "每次只拍摄一种主要食物，多种食物请分别拍摄"
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitle("扫描指南", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("完成")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
            })
        }
    }
}

// 指南项目视图
struct GuideItemView: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 0.1)))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// Lottie动画视图（模拟）
struct LottieAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 5)
                .frame(width: 80, height: 80)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 80, height: 80)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    isAnimating = true
                }
        }
    }
}

#Preview {
    ScanView()
}