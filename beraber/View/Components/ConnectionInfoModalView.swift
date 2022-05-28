//
//  ConnectionInfoModalView.swift
//  beraber
//
//  Created by yozdemir on 28.05.2022.
//

import SwiftUI

struct ConnectionInfoModalView: View {
    var profileData: OtherProfileViewModel
    var body: some View {
        HStack (alignment: .center) {
            VStack {
                VStack {
                    Rectangle()
                        .frame(width: 50, height: 5, alignment: .center)
                        .foregroundColor(.white)
                        .background(.white)
                        .padding(.top, 15)
                        .cornerRadius(50)
                    
                    Text("İletişim Bilgileri")
                        .fontWeight(.bold)
                        .padding(.bottom, 5)
                        .padding(.top, 10)
                        .foregroundColor(.white)
                    Divider()
                }
                
                VStack {
                    HStack(alignment: .bottom) {
                        Divider()
                            .frame(height: 30, alignment: .center)
                        Text(profileData.userInfo.userName)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                            .foregroundColor(.white)
                        Divider()
                            .frame(height: 30, alignment: .center)
                    }
                    
                    VStack {
                        Text("Telefon Numarası")
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                            .font(.caption)
                            .foregroundColor(.white)
                        if profileData.userInfo.showConnectionInfos {
                            Text(profileData.phoneNumberParser(number:profileData.userInfo.phoneNumber))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        } else {
                            Text("(Kullanıcı tarafından gizlenmiştir)")
                                .font(.custom("", size: 8))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(alignment: .leading)
                            Text("(0) 5xx xxx xx xx")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        Divider()
                            .frame(width: UIScreen.screenWidth/2, alignment: .center)
                    }
                    
                    VStack {
                        Text("E-Posta Adresi")
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                            .font(.caption)
                            .foregroundColor(.white)
                        Text(profileData.userInfo.emailAddress)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Divider()
                            .frame(width: UIScreen.screenWidth/2, alignment: .center)
                    }
                    
                    Text("Beraberlik Akımı İçin Müsait Olduğu Günler")
                        .padding(.bottom, 5)
                        .padding(.top, 10)
                        .font(.caption)
                        .foregroundColor(.white)
                    HStack (spacing: 5) {
                        ForEach(profileData.userInfo.possibleDaysOfWeek, id: \.self){ day in
                            Text(day)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }.padding(.bottom,15)
                }.padding(.vertical)
            }
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/2, alignment: .top)
        .background(Color(hex: 0x1B1B1B))
        .cornerRadius(40)
    }
}
