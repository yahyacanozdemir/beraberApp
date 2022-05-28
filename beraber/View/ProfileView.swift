//
//  SettingsView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import ImageViewerRemote

struct ProfileView: View {
    @Binding var tabSelection: String
    @StateObject var postData = PostViewModel()
    @StateObject var profileData = ProfileViewModel()
    
    @State var isUpdatedProfile = false
    @State private var userHasAnyPost: Bool = false
    
    var edges = UIWindow.key?.safeAreaInsets
    var body: some View {
        VStack (alignment: .leading){
            BeraberNavigationView(title: "Profil", withTrailingIcon: true, trailingIconName: "gearshape") { openSettings in
                if openSettings {
                    self.profileData.openSettings.toggle()
                }
            }
            ScrollView{
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    profileData.isLoading = true
                    postData.getAllPosts()
                    fetchUser(uid: self.profileData.userInfo.uid) { UserModel in
                        self.profileData.userInfo = UserModel
                        profileData.isLoading = false
                        self.isUpdatedProfile = false
                    }
                }
                HStack (alignment: .center) {
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
                            
                        }.padding(.leading, 20)
                            .onTapGesture {
                                profileData.picker.toggle()
                            }
                    }
                    
                    Spacer(minLength: 0)
                    
                    VStack (alignment: .leading){
                        
                        if profileData.userInfo.userName != "" {
                            HStack{
                                Text(profileData.userInfo.userName)
                                    .font(.custom("", size: 22))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                        }
                        
                        if (profileData.userInfo.userAge != 0) && profileData.userInfo.showAgeInfos {
                            ProfileInfoCell(title: "Yaş", info: "\(profileData.userInfo.userAge)")
                            .padding(.bottom, 0.2)
                        }
                        
                        if profileData.userInfo.userCreationDate.dateValue() != Date(timeIntervalSince1970: 0) {
                            ProfileInfoCell(title: "Kayıt tarihi", info: "".getCreationDateAsString(date: profileData.userInfo.userCreationDate.dateValue()))
                            .padding(.bottom, 0.2)
                        }
                        
                        if profileData.userInfo.userLocation != ""  && profileData.userInfo.showLocationInfos{
                            ProfileInfoCell(title: "Lokasyon", info: profileData.userInfo.userLocation)
                            .padding(.bottom, 0.2)
                        }
                        
                        if profileData.userInfo.userReasonForApp != "" {
                            ProfileInfoCell(title: "Beraberlikteki rolü", info: profileData.userInfo.userReasonForApp)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer(minLength: 0)
                }
                
                Divider()
                    .background(.white)
                    .padding(.top, 20)
                //                .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
                
                
                VStack(alignment: .leading) {
                    if profileData.userInfo.userBiography != "" {
                        Text("Hakkında")
                            .frame(alignment: .center)
                            .font(.title)
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.top, 10)
                            .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text(profileData.userInfo.userBiography)
                            .font(.custom("", size: 16))
                            .foregroundColor(.white.opacity(0.65))
                            .fontWeight(.thin)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .padding(.top, 10)
                        
                    }
                    
                        Divider()
                            .background(.white)
                            .padding(.top, 20)
                            .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        
                        Text("Paylaşımlar")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.leading, 20)
                            .padding(.top, 10)
                            .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    if !(postData.posts.filter({$0.user.uid == profileData.uid}).isEmpty) {
                        VStack(){
                            if profileData.isLoading {
                                HStack{
                                    Spacer(minLength: 0)
                                    ProgressView()
                                        .frame(width: 50, height: 50, alignment: .center)
                                    Spacer(minLength: 0)
                                }
                            } else {
                                ForEach(postData.posts){ post in
                                    if post.user.uid == profileData.uid {
                                        PostRow(tabSelection: $tabSelection, postData: postData, openOtherUserProfile: $profileData.openOtherUserProfile, postUserUid: $profileData.postUserUid,showPostImage: $profileData.showPostImage, post: post)
                                            .onAppear {
                                                self.userHasAnyPost = true
                                            }
                                    }
                                }
                            }
                            if self.userHasAnyPost && !profileData.isLoading {
                                Text("Sana ait tüm paylaşımları gördün.")
                                    .font(.custom("", size: 14))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding()
                        .padding(.bottom, 10)
                    } else if profileData.isLoading {
                        HStack{
                            Spacer(minLength: 0)
                            ProgressView()
                                .frame(width: 50, height: 50, alignment: .center)
                            Spacer(minLength: 0)
                        }
                    } else {
                        HStack {
                            Spacer(minLength: 0)
                            VStack {
                                Text("Henüz hiçbir paylaşım yapmadın. Hemen bir gönderi yayınla, iyilik akımına dahil ol.")
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
                    }
                    
                }
            }.coordinateSpace(name: "pullToRefresh")
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $postData.newPost){
            NewPostView(updateId : $postData.updateId)
        }
        .popup(isPresented: $isUpdatedProfile, type: .toast , position: .top , closeOnTapOutside: true, dismissCallback: {
            self.isUpdatedProfile = false
        }){
            HStack {
                Text("Sayfayı Yenile ⬇️")
                    .fontWeight(.bold)
                    .frame(width: 200, height: 30)
                    .background(Color(hex: 0x608786))
                    .cornerRadius(30.0)
                    .padding(.top, UIWindow.key?.safeAreaInsets.top)
                    .padding(.horizontal, 20)
            }

        }
        .sheet(isPresented: $profileData.picker) {
            ImagePicker(picker: $profileData.picker, img_data: $profileData.img_data)
        }
        .fullScreenCover(isPresented: $profileData.openSettings,content: {
            SettingsView(openSettings: self.$profileData.openSettings, isUpdatedProfile: self.$isUpdatedProfile)
        })
        .overlay(ImageViewerRemote(imageURL: self.$postData.selectedPostImageUrl, viewerShown: self.$profileData.showPostImage))
        .onChange(of: profileData.img_data) { newData in
            profileData.updateImage()
        }.padding(18)
    }
}

struct ProfileInfoCell: View {
    var title: String
    var info: String
    var body: some View {
        HStack {
            Text("\(title): ")
                .font(.custom("", size: 16))
                .foregroundColor(.white.opacity(0.65))
                .fontWeight(.thin)
                .fixedSize()

            Text("\(info)")
                .font(.custom("", size: 16))
                .foregroundColor(.white.opacity(0.85))
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}
