//
//  PostRow.swift
//  beraber
//
//  Created by yozdemir on 9.04.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase



struct PostRow: View {
    
    @Binding var tabSelection: String
    @ObservedObject var postData = PostViewModel()
    @Binding var openOtherUserProfile: Bool
    @Binding var postUserUid: String
    @Binding var showPostImage: Bool
    
    
    var post: PostModel
    let currentUserUid = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack(spacing: 15){
            HStack(spacing: 10){
                
                if openOtherUserProfile || tabSelection == "Profil" {
                    WebImage(url: URL(string: post.user.userProfilePic)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                    VStack (alignment: .leading, spacing: 3) {
                        Text(post.user.userName)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        Text(post.user.userLocation)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                            .font(.caption)
                    }
                } else {
                    Button {
                        if Auth.auth().currentUser?.uid == post.user.uid {
                            self.tabSelection = "Profil"
                        } else {
                            openOtherUserProfile = true
                            postUserUid = post.user.uid
                        }
                    } label: {
                        WebImage(url: URL(string: post.user.userProfilePic)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            
                        VStack (alignment: .leading, spacing: 3) {
                            Text(post.user.userName)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            Text(post.user.userLocation)
                                .foregroundColor(.white)
                                .fontWeight(.thin)
                                .font(.caption)
                            
                        }
                    }
                }
                
                Spacer(minLength: 0)
                
                if post.user.uid == currentUserUid{
                    Menu(content: {
                        Button {
                            postData.deletePost(id: post.id)
                        } label: {
                            Text("Paylaşımı Sil")
                        }
                    }, label: {
                        Image(systemName: "equal.circle")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    })
                }
                
            }.padding(.bottom, 40)
            
            if post.pic != "" {
                Button {
                    showPostImage.toggle()
                    postData.selectedPostImageUrl = post.pic
                } label: {
                    WebImage(url: URL(string: post.pic)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.screenWidth - 60 , height: 250)
                        .cornerRadius(15)
                }
            }
            
            HStack{
                Text(post.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
            }
            .padding(.top,5)
            
            HStack{
                Spacer(minLength: 0)
                Text(post.time, style: .time)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(.white.opacity(0.06))
        .cornerRadius(15)
    }
}
