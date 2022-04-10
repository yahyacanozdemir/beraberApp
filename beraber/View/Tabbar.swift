//
//  Tabbar.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI

struct Tabbar: View {
    @Binding var selectedTab : String
    var body: some View {
        HStack(spacing: 20){
            TabButton(title: "Anasayfa", iconName: "square.stack.3d.down.forward", selectedTab: $selectedTab)
            TabButton(title: "Mesajlar", iconName: "message", selectedTab: $selectedTab)
            TabButton(title: "Profil", iconName: "person", selectedTab: $selectedTab)
        }
        .padding(.horizontal)
        .background(.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 3)
    }
}

struct TabButton: View {
    var title: String
    var iconName : String
    @Binding var selectedTab: String
    
    var body: some View {
        Button(action: {selectedTab = title}){
            VStack(spacing: 5){
                Image(systemName: iconName)
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == title ? .blue : .gray)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor(selectedTab == title ? .blue : .gray)
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}
