//
//  JoinView.swift
//  beraber
//
//  Created by yozdemir on 29.05.2022.
//

import SwiftUI

struct JoinChatroomModal: View {
    
    @Binding var isOpen: Bool
    @Binding var isOpenFromMessagesPage: Bool
    @Binding var redirectingPostId: String
    @Binding var redirectingPosOwnerId: String
    @Binding var redirectingJoinCode: String
    @Binding var redirectingNewRoomTitle: String
    @State var joinCode = ""
    @State var newTitle = ""
    @ObservedObject var viewModel = ChatroomsViewModel()
    @ObservedObject var postsViewModel = PostViewModel()
    
    var body: some View {
            VStack {
                VStack(alignment: .leading) {
                    Text("Odaya Katıl")
//                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.top, 15)
                        .padding(.horizontal,20)
                    
                    Text("5 haneli eşsiz kodu gir")
//                        .foregroundColor(.white)
                        .font(.caption2)
                        .padding(.horizontal,20)
                        .padding(.bottom, 10)
                    HStack {
                        TextField("Mesaj odasına ait kodu gir", text: $joinCode)
                            .padding()
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                        .strokeBorder(viewModel.isJoinCodeValidated ? Color.black : Color.red, style: StrokeStyle(lineWidth: 1))
                                        .padding(.horizontal))
                            .onChange(of: joinCode) {
                                if $0 == "0" {}
                                viewModel.isJoinCodeValidated = false
                                if joinCode.count == 6 {
                                    joinCode = String(joinCode.prefix(5))
                                }
                                if joinCode.count == 5 {
                                    viewModel.isJoinCodeValidated = true
                                }
                            }
                        Button(action: {
                            UIApplication.shared.endEditing()
                            if joinCode.count == 5 {
                                viewModel.joinChatroom(code: joinCode, handler: {
                                    self.isOpen = false
                                })
                            }
                        }, label: {
                            Image(systemName: "arrow.forward.circle")
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color(hex: 0x608786))
                                .clipShape(Circle())
                        })
                            .padding(.trailing, 10)
                            .disabled(viewModel.createOrJoinProcessLoading)
                            .opacity(viewModel.createOrJoinProcessLoading ? 0.5 : 1 )
                    }
                    .padding(.horizontal,5)
                    
                    if !isOpenFromMessagesPage && (redirectingNewRoomTitle == "") {
                        Text("Sağ taraftaki buton ile gönderiye ait mesaj odasına hemen dahil olabilirsin.")
    //                        .foregroundColor(.white)
                            .font(.caption2)
                            .opacity(0.5)
                            .padding(.horizontal,30)

                    }
                }
                .padding(.bottom)
                
                VStack (alignment: .leading) {
                    Text("Oda Oluştur")
//                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.top, 15)
                        .padding(.horizontal,20)
                    
                    Text("Oda ismi en az 5, en çok 30 karakterden oluşmalıdır")
//                        .foregroundColor(.white)
                        .font(.caption2)
                        .padding(.horizontal,20)
                        .padding(.bottom, 10)
                    
                    HStack {
                        TextField("Mesaj odasına isim ver", text: $newTitle)
                            .padding()
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                            .keyboardType(.alphabet)
                            .padding(.horizontal)
                            .overlay(RoundedRectangle(cornerRadius: 15)
                                        .strokeBorder(viewModel.isRoomTitleValidated ? Color.black : Color.red, style: StrokeStyle(lineWidth: 1))
                                        .padding(.horizontal))
                            .onChange(of: newTitle) {
                                if $0 == "0" {}
                                viewModel.isRoomTitleValidated = false
                                if newTitle.count == 31 {
                                    newTitle = String(newTitle.prefix(30))
                                }
                                if newTitle.count >= 5 && newTitle.count <= 30 {
                                    viewModel.isRoomTitleValidated = true
                                }
                            }
                        Button(action: {
                            UIApplication.shared.endEditing()
                            if newTitle.count >= 5 && newTitle.count <= 30 {
                                if redirectingNewRoomTitle != "" {
                                    viewModel.createChatroom(title: newTitle, joinCode: Int(redirectingJoinCode) ?? 0, postOwnerId: redirectingPosOwnerId, handler: {
                                        self.isOpen = false
                                        postsViewModel.updatePost(id: redirectingPostId)
                                    })
                                } else {
                                    viewModel.createChatroom(title: newTitle, handler: {
                                        self.isOpen = false
                                    })
                                }
                            }
                        }, label: {
                            Image(systemName: "plus.circle")
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color(hex: 0x608786))
                                .clipShape(Circle())
                        }).padding(.trailing, 10)
                            .disabled(viewModel.createOrJoinProcessLoading)
                            .opacity(viewModel.createOrJoinProcessLoading ? 0.5 : 1 )
                    }
                    .padding(.horizontal,5)
                    .padding(.bottom, isOpenFromMessagesPage ? 10 : 0)
                    if !isOpenFromMessagesPage && (redirectingNewRoomTitle != "" || redirectingJoinCode == "") {
                        Text("Gönderiye ait mesaj odası bulunamadı. Yandaki buton ile bu gönderiye ait yeni bir oda oluşturabilirsin.")
    //                        .foregroundColor(.white)
                            .font(.caption2)
                            .opacity(0.5)
                            .padding(.horizontal,30)
                            .padding(.bottom)
                    }
                }
                .padding(.bottom)
            }
            .onAppear(perform: {
                if redirectingNewRoomTitle == "" {
                    joinCode = redirectingJoinCode.filter { $0 != "\"" }
                } else {
                    newTitle = redirectingNewRoomTitle.filter { $0 != "\"" }
                }
            })
            .onDisappear(perform: {
                redirectingJoinCode = ""
                redirectingNewRoomTitle = ""
                redirectingPostId = ""
                redirectingPosOwnerId = ""
            })
            .padding(.bottom, UIWindow.key?.safeAreaInsets.bottom ?? 25 + 10)
            .onTapGesture {
                // Hide Keyboard
                UIApplication.shared.endEditing()
            }
        }
}
