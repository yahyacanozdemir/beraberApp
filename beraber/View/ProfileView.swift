//
//  SettingsView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct ProfileView: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @StateObject var profileData = ProfileViewModel()
    var body: some View {
        VStack{
            HStack{
                Text("Profil")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            if profileData.userInfo.userProfilePic != "" {
                ZStack{
                    Circle()
                        .frame(width: 127, height: 127)
                        .foregroundColor(.white)
                        .padding(.top,20)
                    WebImage(url: URL(string: profileData.userInfo.userProfilePic)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .padding(.top, 20)
                        .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
            
            if profileData.userInfo.userName != "" {
                HStack{
                    Text(profileData.userInfo.userName + " " + profileData.userInfo.userSurname)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    
                    Button(action:{}){
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            
            if profileData.userInfo.userLocation != "" {
                HStack{
                    Text(profileData.userInfo.userLocation)
                        .foregroundColor(.white)
                    
                    Button(action:{}){
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
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
                        .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                }
                .background(.blue)
                .cornerRadius(15)
            }
            .padding()
            
            Spacer(minLength: 0)
        }
    }
}

