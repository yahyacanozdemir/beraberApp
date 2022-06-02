//
//  PostView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI
import ImageViewerRemote

struct PostView: View {
    
    @Binding var tabSelection: String
    @StateObject var postData = PostViewModel()
    @State var openOtherUserProfile = false
    @State var postUserUid = ""
    @State var showPostImage: Bool = false
    

    var body: some View {
        VStack{
            BeraberNavigationView(title: "Anasayfa", withTrailingIcon: false) { _ in }
            if postData.posts.isEmpty {
                Spacer(minLength: 0)
                if postData.noPosts{
                    HStack {
                        Spacer(minLength: 0)
                        VStack {
                            Image("noPostMainPage")
                                .resizable()
                                .frame(width: 192, height: 152, alignment: .center)
                                .padding()
                            Text("Görünüşe göre yakınlarda hiçbir paylaşım yapılmadı. Hemen bir gönderi yayınlayarak, iyilik akımını başlatabilirsin.")
                                .font(.custom("", size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 60)
                            Button {
                                postData.newPost.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                            }.padding(.top, 10)
                        }
                        .padding(.vertical, 10)
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical,60)
                    Spacer(minLength: 0)
                }
                else {
                    ProgressView()
                }
                Spacer(minLength: 0)
            } else {
                ScrollView(showsIndicators: false){
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        postData.getAllPosts()
                    }
                    VStack(spacing: 15){
                        ForEach(postData.posts){ post in
                            PostRow(tabSelection: $tabSelection, postData: postData, openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid,showPostImage: $showPostImage, post: post)
                                .transition(.move(edge: .bottom))
                        }
                    }
                    .padding()
                    .padding(.bottom, 55)
                }.coordinateSpace(name: "pullToRefresh")
            }
        }
        .fullScreenCover(isPresented: $openOtherUserProfile, content: {
            OtherProfileView(tabSelection: $tabSelection, profileData: OtherProfileViewModel(), openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid)
        })
        .fullScreenCover(isPresented: $postData.newPost){
            NewPostView(updateId : $postData.updateId)
        }
        .fullScreenCover(isPresented: self.$showPostImage){
            ImageViewerRemote(imageURL: self.$postData.selectedPostImageUrl, viewerShown: self.$showPostImage)
                .background(Color(red: 0.12, green: 0.12, blue: 0.12, opacity: (1.0)))
        }
        .padding(18)
    }
}
