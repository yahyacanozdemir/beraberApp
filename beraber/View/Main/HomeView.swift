//
//  HomeView.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI
import PartialSheet

struct HomeView: View {
    @State var selectedTab = "Anasayfa"
    @State var openMessageJoinModal = false
    @State var openNewPostView = false
    @StateObject var postData = PostViewModel()

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            //Tabbar
            ZStack{
                PostView(tabSelection: $selectedTab,openMessageJoinModal: $openMessageJoinModal, openNewPostView: $openNewPostView)
                    .opacity(selectedTab == "Anasayfa" ? 1 : 0)
                MessagesPagesView(tabSelection: $selectedTab, openMessageJoinModal: $openMessageJoinModal)
                    .opacity(selectedTab == "Mesajlar" ? 1 : 0)
                ProfileView(tabSelection: $selectedTab, openMessageJoinModal: $openMessageJoinModal)
                    .opacity(selectedTab == "Profil" ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Tabbar(selectedTab: $selectedTab)
                if selectedTab == "Anasayfa" {
                    Button {
                        self.openNewPostView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .attachPartialSheetToRoot()
        .padding(.horizontal, -20)
        .background(Color(hex: 0x465D8B))
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
