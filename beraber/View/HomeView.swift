//
//  HomeView.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab = "Anasayfa"
    @StateObject var postData = PostViewModel()

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            //Tabbar
            
            ZStack{
                PostView(tabSelection: $selectedTab)
                    .opacity(selectedTab == "Anasayfa" ? 1 : 0)
                    .fullScreenCover(isPresented: $postData.newPost){
                        NewPostView(updateId : $postData.updateId)
                    }
                MessagesView(tabSelection: $selectedTab)
                    .opacity(selectedTab == "Mesajlar" ? 1 : 0)
                ProfileView(tabSelection: $selectedTab)
                    .opacity(selectedTab == "Profil" ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Tabbar(selectedTab: $selectedTab)
                if selectedTab == "Anasayfa" {
                    Button {
                        postData.newPost.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                }
            }
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
