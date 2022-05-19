//
//  OtherProfileView.swift
//  beraber
//
//  Created by yozdemir on 5.05.2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import ExytePopupView

struct OtherProfileView: View {
    @State var showUserImage: Bool = false
    @State var showPostImage: Bool = false
    @Binding var tabSelection: String
    @StateObject var profileData: OtherProfileViewModel
    @StateObject var postData = PostViewModel()
    @Binding var openOtherUserProfile: Bool
    @Environment(\.presentationMode) var present
    @Binding var postUserUid: String
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State private var userHasAnyPost: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                    HStack{
                            Image(systemName: "arrow.backward")
                                .font(.title)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    present.wrappedValue.dismiss()
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
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            ScrollView {
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
                                self.showUserImage.toggle()
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    
                    HStack {
                        Spacer(minLength: 0)
                        VStack (alignment: .center){
                            if profileData.userInfo.userCreationDate.dateValue() != Date(timeIntervalSince1970: 0) {
                                HStack {
                                    Text("Kayıt tarihi: ")
                                        .font(.custom("", size: 16))
                                        .foregroundColor(.white.opacity(0.85))
                                    Text("".getCreationDateAsString(date: profileData.userInfo.userCreationDate.dateValue()))
                                        .font(.custom("", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                                .padding(.bottom, 0.2)
                            }
                            
                            if profileData.userInfo.userReasonForApp != "" {
                                HStack {
                                    Text("Beraberlikteki rolü: ")
                                        .font(.custom("", size: 16))
                                        .foregroundColor(.white.opacity(0.85))
                                    Text(profileData.userInfo.userReasonForApp)
                                        .font(.custom("", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white.opacity(0.85))
                                }
                                .padding(.bottom, 0.2)
                            }
                            
                            if profileData.userInfo.userLocation != "" {
                                HStack {
                                    Text("Lokasyon: ")
                                        .font(.custom("", size: 16))
                                        .foregroundColor(.white.opacity(0.85))
                                    Text(profileData.userInfo.userLocation)
                                        .font(.custom("", size: 16))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white.opacity(0.85))
                                }
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
                                        PostRow(tabSelection: $tabSelection, postData: postData, openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid,showPostImage: $showPostImage, post: post)
                                            .onAppear {
                                                self.userHasAnyPost = true
                                            }
                                    }
                                    if self.userHasAnyPost {
                                        Text("Bu kullanıcıya ait tüm paylaşımları gördün.")
                                            .font(.custom("", size: 14))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                                .padding()
                                .padding(.bottom, 10)
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
            print("+++++PostUserUid", self.postUserUid)
            if self.postUserUid != "" {
                profileData.fetchOtherUser(uid: postUserUid)
            }
        })
        .onDisappear {
            openOtherUserProfile = false
        }
        .popup(isPresented: self.$showUserImage,type: .default, dragToDismiss: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.8)) {
            VStack {
                WebImage(url: URL(string: profileData.userInfo.userProfilePic)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.screenWidth-60, height: UIScreen.screenHeight/2)
                    .cornerRadius(24)
            }
        }
        .popup(isPresented: self.$showPostImage,type: .default, dragToDismiss: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.8)) {
            VStack {
                WebImage(url: URL(string: postData.selectedPostImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.screenWidth-30, height: UIScreen.screenHeight/2)
                    .cornerRadius(24)
            }
        }
        
    }
}
