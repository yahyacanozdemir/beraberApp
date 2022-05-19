//
//  SettingsView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import ExytePopupView

struct ProfileView: View {
    @Binding var tabSelection: String
    @StateObject var postData = PostViewModel()
    @StateObject var profileData = ProfileViewModel()
    @State var openOtherUserProfile = false
    @State var showPostImage: Bool = false
    @State var postUserUid = ""
    
    @State private var userHasAnyPost: Bool = false
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    var body: some View {
        VStack (alignment: .leading){
            HStack{
                VStack {
                    Text("BERABER")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .padding(.top, -30)
                    HStack{
                        Text("Profil")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Spacer(minLength: 0)
                        
                        Button(action:{
                            print("clicked settings")
                        }){
                            Image(systemName: "gear.circle")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
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
                            
                            
                            //                            Button(action:{
                            //                                profileData.updateUserDetails(field: "name")
                            //                            }){
                            //                                Image(systemName: "pencil.circle.fill")
                            //                                    .font(.system(size: 24))
                            //                                    .foregroundColor(.white)
                            //                            }
                        }
                        .padding(.bottom, 10)
                        .padding(.top, 10)
                    }
                    if profileData.userInfo.userCreationDate.dateValue() != Date(timeIntervalSince1970: 0) {
                        HStack {
                            Text("Kayıt tarihi: ")
                                .font(.custom("", size: 16))
                                .foregroundColor(.white.opacity(0.85))
                            Text("".getCreationDateAsString(date: profileData.userInfo.userCreationDate.dateValue()))
                                .font(.custom("", size: 16))
                                .foregroundColor(.white.opacity(0.85))
                                .fontWeight(.bold)
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
                                .foregroundColor(.white.opacity(0.85))
                                .fontWeight(.bold)
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
                                .foregroundColor(.white.opacity(0.85))
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            
            Divider()
                .background(.white)
                .padding(.top, 20)
//                .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            
            ScrollView{
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
                            .frame(alignment: .center)
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
                            .padding(.top, 10)
                            .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        VStack(){
                            ForEach(postData.posts){ post in
                                if post.user.uid == profileData.uid {
                                    PostRow(tabSelection: $tabSelection, postData: postData, openOtherUserProfile: $openOtherUserProfile, postUserUid: $postUserUid,showPostImage: $showPostImage, post: post)
                                        .onAppear {
                                            self.userHasAnyPost = true
                                        }
                                }
                            }
                            if self.userHasAnyPost {
                                Text("Sana ait tüm paylaşımları gördün.")
                                    .font(.custom("", size: 14))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding()
                        .padding(.bottom, 10)
                    }
                    
                }
                
                //LogoutButton
                HStack {
                    Button(action: profileData.logOut) {
                        Text("Çıkış Yap")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width-100)
                            .background(Color(red: 211/255, green: 109/255, blue: 89/255))
                    }
                    .background(.blue)
                    .cornerRadius(15)
                }
                .padding(.bottom, 60)
                
                Spacer(minLength: 0)
            }
        }
        .sheet(isPresented: $profileData.picker) {
            ImagePicker(picker: $profileData.picker, img_data: $profileData.img_data)
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
        .onChange(of: profileData.img_data) { newData in
            profileData.updateImage()
        }
        .padding(18)
    }
}

