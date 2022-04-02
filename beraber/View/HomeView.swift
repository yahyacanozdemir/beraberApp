//
//  HomeView.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab = "Anasayfa"
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            //Tabbar
            
            ZStack{
                PostView()
                    .opacity(selectedTab == "Anasayfa" ? 1 : 0)
                MessagesView()
                    .opacity(selectedTab == "Mesajlar" ? 1 : 0)
                ProfileView()
                    .opacity(selectedTab == "Profil" ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Tabbar(selectedTab: $selectedTab)
        }
        .background(Color(hex: 0x465D8B))
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
