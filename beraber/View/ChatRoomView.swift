//
//  ChatView.swift
//  beraber
//
//  Created by yozdemir on 30.05.2022.
//

import SwiftUI
import Firebase

struct ChatRoomView: View {
    @Binding var tabSelection: String
    @Binding var openMessageJoinModal: Bool

    @ObservedObject var viewModel = MessagesViewModel()
    @State var messageField = ""
    @State var openOtherUserProfile = false
    @State var selectedMessageUserUid = ""
    @State var counter = 0
    @State var chatRoomUserCount = 0
    
    let chatroom: Chatroom
    var edges = UIWindow.key?.safeAreaInsets
    
    @Environment(\.presentationMode) var present

    
    init(chatroom: Chatroom, selectedTab: Binding<String>, openMessageJoinModal: Binding<Bool>) {
        self._tabSelection = selectedTab
        self._openMessageJoinModal = openMessageJoinModal
        self.chatroom = chatroom
        if counter == 0 {
            viewModel.fetchData(docId: chatroom.id)
        }
        self.counter = 1
    }
    
    
    var body: some View {
        VStack {
            HStack{
                VStack {
                    Text("BERABER")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .padding(.top, -60)
                    HStack{
                        Image(systemName: "arrow.backward")
                            .font(.title)
                            .foregroundColor(.white)
                            .onTapGesture {
                                present.wrappedValue.dismiss()
                            }
                        VStack(alignment: .leading) {
                            Text(self.chatroom.title)
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            HStack {
                                Text("Odanın özel kodu:")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                Text(String(self.chatroom.joinCode))
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .fontWeight(.heavy)
                                    Spacer(minLength: 0)
                                
                                Spacer(minLength: 0)
                                
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.top,-30)
                }
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            ScrollViewReader { reader in
                ScrollView(.vertical, showsIndicators: false) {
                    Text("Bu oda " + chatroom.creatorName + " tarafından " + "".getCreationDateAsString(date: chatroom.createdAt.dateValue()) + " tarihinde oluşturuldu.")
                        .font(.caption)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    LazyVStack(alignment: .center, spacing: 15) {
                        ForEach(viewModel.messages) { message in
                            MessageRow(tabSelection: $tabSelection, selectedMessageUserUid: $selectedMessageUserUid, openOtherUserProfile: $openOtherUserProfile, message: message, isFromCurrentUser: message.senderId == Auth.auth().currentUser?.uid)
                        }
                    }
                    .padding()
                    .padding(.bottom, 15)
                    .id("MSG_VIEW")
                }
                .onChange(of: viewModel.messages.count, perform: { newValue in
                    withAnimation {
                        reader.scrollTo("MSG_VIEW", anchor: .bottom)
                    }
                })
//                .onChange(of: viewModel.messages.count, perform: { newValue in
//                    let isLastMessageCurrentUser = viewModel.messages.filter{$0.senderId == currentUserUid }.last
//                    if isLastMessageCurrentUser != nil {
//                        withAnimation {
//                            reader.scrollTo("MSG_VIEW", anchor: .bottom)
//                        }
//                    }
//                })
            }
            .onAppear(perform: {
                viewModel.fetchData(docId: chatroom.id)
            })
            HStack {
                TextField("Bir mesaj yaz...", text: $messageField)
                    .padding()
                    .background(.white.opacity(0.6))
                    .cornerRadius(15)
                    .keyboardType(.alphabet)
                    
                Button {
                    viewModel.sendMessage(messageContent: messageField, docId: chatroom.id)
//                    UIApplication.shared.endEditing()
                    messageField = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color(hex: 0x608786))
                        .clipShape(Circle())
                }
                .disabled(messageField == "")
                .opacity(messageField == "" ? 0.5 : 1)

            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(Color(hex: 0x465D8B))
        .highPriorityGesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
                    .onEnded { value in
                        if abs(value.translation.height) < abs(value.translation.width) {
                            if abs(value.translation.width) > 50.0 {
                                if value.translation.width > 0 {
                                    present.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                )
        .fullScreenCover(isPresented: $openOtherUserProfile, content: {
            OtherProfileView(tabSelection: $tabSelection,openMessageJoinModal: $openMessageJoinModal ,profileData: OtherProfileViewModel(), openOtherUserProfile: $openOtherUserProfile, postUserUid: $selectedMessageUserUid)
        })
    }
}
