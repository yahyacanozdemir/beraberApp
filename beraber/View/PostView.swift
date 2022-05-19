//
//  PostView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI
import ExytePopupView
import SDWebImageSwiftUI

struct PostView: View {
    
    @Binding var tabSelection: String
    @StateObject var postData = PostViewModel()
    @State var openOtherUserProfile = false
    @State var showPopup = false
    @State var postUserUid = ""
    @State var showPostImage: Bool = false
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets

    var body: some View {
        VStack{
            HStack{
                VStack {
                    Text("BERABER")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
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
                            PostRow(tabSelection: $tabSelection, postData: postData, openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid,showPostImage: $showPostImage, post: post)
                        }
                    }
                    .padding()
                    .padding(.bottom, 55)
                }
            }
        }
        .fullScreenCover(isPresented: $openOtherUserProfile, content: {
            OtherProfileView(tabSelection: $tabSelection, profileData: OtherProfileViewModel(), openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid)
        })
        .fullScreenCover(isPresented: $postData.newPost){
            NewPostView(updateId : $postData.updateId)
        }
        .popup(isPresented: self.$showPostImage,type: .default, dragToDismiss: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.8)) {
            VStack {
                WebImage(url: URL(string: self.postData.selectedPostImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth-30, height: UIScreen.screenHeight/2)
                    .cornerRadius(24)
            }
        }
        .padding(18)
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostView()
//    }
//}
