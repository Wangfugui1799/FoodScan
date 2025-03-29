//
//  MainTabView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 内容区域
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .scan:
                    ScanView()
                case .recommend:
                    RecommendView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 底部导航栏
            VStack(spacing: 0) {
                Divider()
                TabBarView(selectedTab: $selectedTab)
            }
            .background(Color.white)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainTabView()
}