//
//  MessageRow.swift
//  beraber
//
//  Created by yozdemir on 30.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageRow: View {
    @Binding var tabSelection: String
    @Binding var selectedMessageUsrUid: String
    @Binding var openOtherUserProfile: Bool
    @State var dummyTabSelection = ""
    @Environment(\.presentationMode) var present

    var message: Message
    var isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
            }
            
            HStack(alignment: .bottom, spacing: 10) {
                
                if !isFromCurrentUser {
                    UserView(message: message, isFromCurrentUser: isFromCurrentUser)
                        .offset(y: 10)
                        .onTapGesture {
                            selectedMessageUsrUid = message.senderId ?? ""
                            openOtherUserProfile = true
                        }
                }
            
                VStack(alignment: isFromCurrentUser ? .trailing : .leading, spacing: 6) {
                    Text(message.content)
                    Text(message.createdTime.dateValue(), style: .time)
                        .font(.caption)
                }
                .padding([.horizontal, .top])
                .padding(.bottom, 8)
                .background(isFromCurrentUser ? .blue : .gray.opacity(0.4))
                .clipShape(ChatBubble(corners: isFromCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight]))
                .foregroundColor(.white)
                .frame(width: UIScreen.screenWidth - 150, alignment: isFromCurrentUser ? .trailing : .leading)
                
                if isFromCurrentUser {
                    UserView(message: message, isFromCurrentUser: isFromCurrentUser)
                        .offset(y: 10)
                        .onTapGesture {
                            present.wrappedValue.dismiss()
                            self.tabSelection = "Profil"
                        }
                }
            }
            
            if !isFromCurrentUser {
                Spacer()
            }
        }
    }
}


struct UserView: View {
    var message: Message
    var isFromCurrentUser: Bool
    
    var body: some View {
        if message.senderProfilePic == "" {
            Circle()
                .fill(isFromCurrentUser ? . blue : .gray.opacity(0.6))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(message.senderName != "" ? message.senderName.prefix(1).uppercased() : message.content.prefix(1).uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
                .contextMenu {
                    Text(message.senderName)
                    Text("Durum: offline")
                }
        } else {
            Circle()
                .fill(isFromCurrentUser ? . blue : .gray.opacity(0.6))
                .frame(width: 40, height: 40)
                .overlay(
                    WebImage(url: URL(string: message.senderProfilePic))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                    //                        .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .contextMenu {
                    Text(message.senderName)
                    Text("Durum: offline")
                }
        }
    }
}
