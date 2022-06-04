//
//  MessagesView.swift
//  beraber
//
//  Created by yozdemir on 3.04.2022.
//

import SwiftUI
import PartialSheet
import ExytePopupView
import Firebase

struct MessagesPagesView: View {
    @Binding var tabSelection: String
    @ObservedObject var chatroomsData = ChatroomsViewModel()
    @ObservedObject var viewModel = MessagesViewModel()
    @ObservedObject var settingsData = SettingsViewModel()
    var edges = UIWindow.key?.safeAreaInsets
    
    @State private var joinModal = false
    @State private var openChatPage = false
    @State private var showLeaveChatroomAlert: Bool = false
    @State private var showComplainChatroomAlert: Bool = false
    @State private var showFeedbackPopup: Bool = false
    @State private var feedbackPopupTitle: String = ""
    @State private var numberOfChatRoom = 0


    
    @State var selectedChatRoom: Chatroom = Chatroom(id: "", title: "",creatorUid: "",creatorName: "",createdAt: Timestamp(date: Date(timeIntervalSince1970: 0)), joinCode: -1)

    
    var body: some View {
        VStack{
            BeraberNavigationView(title: "Mesajlar", withTrailingIcon: true, trailingIconName: "square.and.pencil") { iconTapped in
                joinModal = iconTapped
            }
            ScrollView (showsIndicators: false){
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    chatroomsData.fetchData()
                }
                VStack(spacing: 15){
                    if chatroomsData.isLoading {
                        HStack {
                            Spacer(minLength: 0)
                            ProgressView()
                            .padding(.vertical, 10)
                            Spacer(minLength: 0)
                        }
                    } else if chatroomsData.noChatroom {
                        HStack {
                            Spacer(minLength: 0)
                            VStack {
                                Image("paperplane")
                                    .resizable()
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .padding()
                                
                                Text("Henüz hiçbir mesaj odasında bulunmuyorsun. Hemen bir tanesine katılabilir ya da yeni bir tane oluşturabilirsin.")
                                    .font(.custom("", size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white.opacity(0.5))
                                    .padding(.horizontal, 60)
                                Button {
                                    joinModal = true
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 30))
                                        .foregroundColor(.white)
                                }.padding(.top, 10)
                            }
                            .padding(.vertical, 10)
                            Spacer(minLength: 0)
                        }.onAppear {
                            self.numberOfChatRoom = 0
                        }
                    } else {
                        ForEach(chatroomsData.chatrooms){ room in
                            VStack {
                                Button {
                                    self.selectedChatRoom = room
                                    openChatPage = true
                                } label: {
                                    HStack {
                                        Circle()
                                            .fill(Color(hex:0xB4E0D1))
                                            .frame(width: 55, height: 55)
                                            .overlay(
                                                Text(room.title.prefix(1).uppercased())
                                                .font(.title)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                            )
                                        Text(room.title)
                                            .foregroundColor(.white)
                                            .font(.title2)
                                            .multilineTextAlignment(.leading)
                                        Spacer(minLength: 0)
                                    }.onAppear {
                                        numberOfChatRoom += 1
                                    }
                                }
                                .contextMenu{
                                    VStack {
                                        Button {
                                            self.showLeaveChatroomAlert = true
                                        } label: {
                                            Text("Mesaj odasından ayrıl")
                                        }
                                        .onAppear {
                                            viewModel.fetchData(docId: self.selectedChatRoom.id)
                                        }
                                        Button {
                                            self.showComplainChatroomAlert = true
                                        } label: {
                                            Text("Mesaj odasını şkayet et")
                                        }
                                    }.onAppear {
                                        self.selectedChatRoom = room
                                    }
                                }.alert("Odadan ayrılmak istediğine emin misin?", isPresented: $showLeaveChatroomAlert) {
                                    Button("Ayrıl") {
                                        chatroomsData.leaveChatRoom(code: "\(selectedChatRoom.joinCode)") {
                                            showFeedbackPopup = true
                                            feedbackPopupTitle = "Ayrılma Başarılı"
                                        }
                                    }
                                    Button("Vazgeç") {self.showLeaveChatroomAlert = false}
                                }
                                .alert("Şikayet özelliği yakında kullanıma açılacaktır 🙄", isPresented: $showComplainChatroomAlert) {
                                    Button("Tamam") {self.showComplainChatroomAlert = false}
                                }
                                .onAppear {
                                    self.selectedChatRoom = room
                                }
                                Divider()
                                    .background(.white)
                                    .padding(.vertical, 5)
                                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                        }.onAppear {
                            settingsData.updateNumberOfChatRooms(roomNumber: self.numberOfChatRoom)
                            self.numberOfChatRoom = 0
                        }
                    }
                }
                .padding()
                .padding(.bottom, 55)
            }.coordinateSpace(name: "pullToRefresh")
        }
        .padding(18)
        .partialSheet(isPresented: $joinModal, content: {
            JoinChatroomModal(isOpen: self.$joinModal)
        })
        .fullScreenCover(isPresented: $openChatPage) {
            ChatRoomView(chatroom: self.selectedChatRoom, selectedTab: $tabSelection)
                .onAppear {
                    viewModel.fetchData(docId: self.selectedChatRoom.id)
                }
        }
        .popup(isPresented: $showFeedbackPopup, type: .toast , position: .top ,autohideIn: 3, closeOnTapOutside: true, dismissCallback: {
            self.showFeedbackPopup = false
        }){
            Text(feedbackPopupTitle)
                .fontWeight(.bold)
                .frame(width: 200, height: 40)
                .foregroundColor(.white)
                .background(Color(hex: 0x608786))
                .cornerRadius(30.0)
                .padding(.top, UIWindow.key?.safeAreaInsets.top)
                .padding(.horizontal, 20)
        }

    }
}
