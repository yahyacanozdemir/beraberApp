//
//  PostView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI

struct PostView: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @StateObject var postData = PostViewModel()
    var body: some View {
        VStack{
            HStack{
                VStack {
                    Text("BERABER")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.top, -30)
                    HStack{
                        Text("Anasayfa")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Spacer(minLength: 0)

                    }
                }
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            if postData.posts.isEmpty {
                Spacer(minLength: 0)
                if postData.noPosts{
                    Text("Henüz hiçbir paylaşım yapılmamıştır.")
                } else {
                    ProgressView()
                }
                Spacer(minLength: 0)
            } else {
                ScrollView{
                    VStack(spacing: 15){
                        ForEach(postData.posts){ post in
                            PostRow(post: post, postData: postData)
                        }
                    }
                    .padding()
                    .padding(.bottom, 55)
                }
            }
        }
        .fullScreenCover(isPresented: $postData.newPost){
            NewPostView(updateId : $postData.updateId)
        }
        .padding(18)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
