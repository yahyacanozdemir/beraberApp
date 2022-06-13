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
    
    @Binding var tabSelection: HomeView.MainTabs
    @Binding var openMessageJoinModal: Bool
    @Binding var redirectingPostId: String
    @Binding var redirectingPosOwnerId: String
    @Binding var redirectingJoinCode: String
    @Binding var redirectingNewRoomTitle: String

    @ObservedObject var postData = PostViewModel()
    @Binding var openOtherUserProfile: Bool
    @Binding var postUserUid: String
    @Binding var showPostImage: Bool
    
    @Environment(\.presentationMode) var present
    @State private var showDeletePostAlert: Bool = false
    
    
    var post: PostModel
    let currentUserUid = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack(spacing: 15){
            HStack{
                Spacer(minLength: 0)
                if post.user.uid == currentUserUid{
                    Button(action: {
                        self.showDeletePostAlert.toggle()
                    }, label: {
                        Image(systemName: "trash.circle")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }).alert("Paylaşımını silmek istediğine emin misin?", isPresented: $showDeletePostAlert) {
                        Button("Sil") {postData.deletePost(id: post.id)}
                        Button("Vazgeç") {self.showDeletePostAlert = false}
                    }
                } else {
                    Button(action: {
                        self.showDeletePostAlert.toggle()
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }).alert("Gönderiye ait mesaj odasına gidiyorsun", isPresented: $showDeletePostAlert) {
                        Button("Beni oraya götür") {
                            present.wrappedValue.dismiss()
                            tabSelection = .Mesajlar
                            if post.hasChatroom{
                                redirectingJoinCode = post.chatRoomCode
                            } else {
                                redirectingPostId = post.id
                                redirectingPosOwnerId = post.user.uid
                                redirectingJoinCode = post.chatRoomCode
                                redirectingNewRoomTitle = post.title
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                openMessageJoinModal.toggle()
                            }
                        }
                        Button("Vazgeç") {self.showDeletePostAlert = false}
                    }
                }
            }
            HStack(spacing: 10){
                if openOtherUserProfile || tabSelection == .Profil {
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
                        if currentUserUid == post.user.uid {
                            self.tabSelection = .Profil
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
                
            }
            .padding(15)
            .padding(.top, -50)
            
            HStack{
                Text(post.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
            }
            .padding(.leading, 5)
            
                Divider()
                    .background(.white)
                    .padding(.vertical, 5)
            
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
                Text(post.description)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                Spacer(minLength: 0)
            }
            .padding(.top,5)
            .padding(.leading, 5)
            
            HStack {
                Spacer(minLength: 0)
                Text("".getCreationDateAsString(date: post.time))
                    .font(.caption2)
                    .foregroundColor(.white)
                Text(post.time, style: .time)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(.white.opacity(0.06))
        .cornerRadius(15)
    }
}
