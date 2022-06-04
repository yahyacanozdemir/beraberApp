//
//  OtherProfileView.swift
//  beraber
//
//  Created by yozdemir on 5.05.2022.
//

import SwiftUI
import ImageViewerRemote
import ExytePopupView
import SDWebImageSwiftUI

struct OtherProfileView: View {
    @Binding var tabSelection: String
    @StateObject var profileData: OtherProfileViewModel
    @StateObject var postData = PostViewModel()
    @Binding var openOtherUserProfile: Bool
    @Binding var postUserUid: String
    
    var edges = UIWindow.key?.safeAreaInsets
    @State private var userHasAnyPost: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                    HStack{
                            Image(systemName: "arrow.backward")
                                .font(.title)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    openOtherUserProfile = false
//                                    present.wrappedValue.dismiss()
                                }
                        Spacer(minLength: 0)
                        if profileData.isLoading {
                            ProgressView()
                        } else {
                            Text(profileData.userInfo.userName)
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                        Spacer(minLength: 0)
                        Button {
                            self.profileData.openUserConnectionInfos.toggle()
                        } label: {
                            Image(systemName: "rectangle.3.group.bubble.left.fill")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack (alignment: .center) {
                        Spacer(minLength: 0)
                        if profileData.userInfo.userProfilePic != "" {
                            ZStack{
                                Circle()
                                    .frame(width: 102, height: 102)
                                    .foregroundColor(.white)
                                    .padding(.top,20)
                                WebImage(url: URL(string: profileData.userInfo.userProfilePic)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .padding(.top, 20)
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                                if profileData.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.top, 20)
                                }
                            }
                            .onTapGesture {
                                self.profileData.showUserImage.toggle()
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    
                    HStack {
                        Spacer(minLength: 0)
                        VStack (alignment: .center){
                            
                            if (profileData.userInfo.userAge != 0) && profileData.userInfo.showAgeInfos {
                                OtherProfileInfoCell(title: "Yaş", info: "\(profileData.userInfo.userAge)")
                                    .padding(.bottom, 0.2)
                            }
                            
                            if profileData.userInfo.userCreationDate.dateValue() != Date(timeIntervalSince1970: 0) {
                                OtherProfileInfoCell(title: "Kayıt tarihi", info: "".getCreationDateAsString(date: profileData.userInfo.userCreationDate.dateValue()))
                                    .padding(.bottom, 0.2)
                            }
                            
                            if profileData.userInfo.userLocation != "" && profileData.userInfo.showLocationInfos{
                                OtherProfileInfoCell(title: "Lokasyon", info: profileData.userInfo.userLocation)
                                    .padding(.bottom, 0.2)
                            }
                            
                            if profileData.userInfo.userReasonForApp != "" {
                                OtherProfileInfoCell(title: "Beraberlikteki rolü", info: profileData.userInfo.userReasonForApp == "İkisi de" ? "Duyurucu & Bağışçı" : profileData.userInfo.userReasonForApp)
                                    .padding(.bottom, 0.2)
                            }
                            
                            if profileData.userInfo.userReasonForApp != "" {
                                OtherProfileInfoCell(title: "Bulunduğu oda sayısı", info: String(profileData.userInfo.numberOfRooms))
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 20)
                    
                    Divider()
                        .background(.white)
                        .padding(.top, 20)
                        
                    VStack(alignment: .center) {
                            if profileData.userInfo.userBiography != "" {
                                Text("Hakkında")
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .foregroundColor(.white.opacity(0.85))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                                    .padding(.top, 10)
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                                    .foregroundColor(.white.opacity(0.85))

                                
                                Text(profileData.userInfo.userBiography)
                                    .multilineTextAlignment(.center)
                                    .font(.custom("", size: 16))
                                    .foregroundColor(.white.opacity(0.85))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                                    .padding(.top, 10)
                            }
                            
                            if profileData.userInfo.userBiography != "" {
                                Divider()
                                    .background(.white)
                                    .padding(.top, 20)
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                
                                Text("Paylaşımlar")
                                    .font(.title)
                                    .foregroundColor(.white.opacity(0.85))
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                                    .padding(.top, 10)
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                VStack(){
                                    ForEach(postData.posts.filter({ post in
                                        post.user.uid == postUserUid
                                    })){ post in
                                        PostRow(tabSelection: $tabSelection, postData: postData, openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid,showPostImage: $profileData.showPostImage, post: post)
                                            .onAppear {
                                                self.userHasAnyPost = true
                                            }
                                    }
                                    if self.userHasAnyPost && !profileData.isLoading {
                                        Text("Bu kullanıcıya ait tüm paylaşımları gördün.")
                                            .font(.custom("", size: 14))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                                .padding()
                                .padding(.bottom, 10)
                                
                                if !userHasAnyPost {
                                    HStack {
                                        Spacer(minLength: 0)
                                        VStack {
                                            Image("noPostVector")
                                                .resizable()
                                                .frame(width: 171, height: 114, alignment: .center)
                                                .padding()
                                            Text("Bu kullanıcı henüz hiçbir paylaşımda bulunmadı.")
                                                .font(.custom("", size: 14))
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.white.opacity(0.5))
                                                .padding(.horizontal, 60)
                                        }
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.top, -50)
                                    .padding(.bottom,10)
                                }
                            }
                        }
                        
                        Spacer(minLength: 0)
                }
            }
            Spacer(minLength: 0)
        }
        .background(Color(hex: 0x465D8B))
        .ignoresSafeArea(.all, edges: .top)
        .onAppear(perform: {
            if self.postUserUid != "" {
                profileData.fetchOtherUser(uid: postUserUid)
            }
        })
        .onDisappear {
            openOtherUserProfile = false
        }
        .highPriorityGesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
                                .onEnded { value in
            if !self.profileData.showUserImage || !self.profileData.showPostImage {
                if abs(value.translation.height) < abs(value.translation.width) {
                    if abs(value.translation.width) > 50.0 {
                        if value.translation.width > 0 {
                            self.swipeLeftToRight()
                        }
                    }
                }
            }
        }
        )
        .overlay(ImageViewerRemote(imageURL: self.$profileData.userInfo.userProfilePic, viewerShown: self.$profileData.showUserImage))
        .overlay(ImageViewerRemote(imageURL: self.$postData.selectedPostImageUrl, viewerShown: self.$profileData.showPostImage))
        .popup(isPresented: $profileData.openUserConnectionInfos, type: .toast, position: .bottom ,closeOnTapOutside: true) {
            ConnectionInfoModalView(profileData: self.profileData)
        }
    }
    
    func swipeLeftToRight() {
        openOtherUserProfile = false
    }
}

struct OtherProfileInfoCell: View {
    var title: String
    var info: String
    var body: some View {
        HStack {
            Text("\(title): ")
                .font(.custom("", size: 16))
                .foregroundColor(.white.opacity(0.85))
            Text("\(info)")
                .font(.custom("", size: 16))
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.85))
        }
    }
}
