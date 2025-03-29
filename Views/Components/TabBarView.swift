//
//  TabBarView.swift
//  foodscan
//
//  Created by Trae AI on 2025/3/29.
//

import SwiftUI

enum TabItem {
    case home, scan, recommend, profile
    
    var title: String {
        switch self {
        case .home: return "首页"
        case .scan: return "识别"
        case .recommend: return "推荐"
        case .profile: return "我的"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .scan: return "camera.fill"
        case .recommend: return "lightbulb.fill"
        case .profile: return "person.fill"
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack {
            ForEach([TabItem.home, .scan, .recommend, .profile], id: \.self) { tab in
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 22))
                    Text(tab.title)
                        .font(.system(size: 12))
                }
                .foregroundColor(selectedTab == tab ? .green : .gray)
                .onTapGesture {
                    selectedTab = tab
                }
                Spacer()
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
    }
}

#Preview {
    TabBarView(selectedTab: .constant(.home))
}