//
//  MessageView.swift
//  beraber
//
//  Created by yozdemir on 29.05.2022.
//

import SwiftUI

struct MessageView: View {
    
    let chatroom: Chatroom
    @ObservedObject var viewModel = MessagesViewModel()
    @State var messageField = ""
    
    @Environment(\.presentationMode) var present

    
    init(chatroom: Chatroom) {
        self.chatroom = chatroom
        viewModel.fetchData(docId: chatroom.id)
    }
    
    var body: some View {
        VStack{
            BeraberNavigationView(title: self.chatroom.title, withTrailingIcon: false) {_ in}
            ScrollView(showsIndicators: false){
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    viewModel.fetchData(docId: chatroom.id)
                }
                VStack(spacing: 15){
                    ForEach(viewModel.messages){ message in
                        VStack {
                            HStack {
                                Text(message.content)
                                    .foregroundColor(.white)
                                    .font(.caption)
                                Spacer(minLength: 0)
                            }
                            Divider()
                                .background(.white)
                                .padding(.top, 20)
                                .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 5)
            }.coordinateSpace(name: "pullToRefresh")
            
            HStack {
                TextField("Mesaj yaz...", text: $messageField)
                    .padding()
                    .background(.white.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .keyboardType(.alphabet)
                Button(action: {
                    viewModel.sendMessage(messageContent: messageField, docId: chatroom.id)
                    UIApplication.shared.endEditing()
                    messageField = ""
                }, label: {
                    Text("Gönder")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .padding(.horizontal)
                        .background(Color(hex: 0x608786))
                        .cornerRadius(15)
                })
            }.padding()
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
    }
}
