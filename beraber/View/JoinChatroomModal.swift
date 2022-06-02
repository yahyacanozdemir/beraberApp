//
//  JoinView.swift
//  beraber
//
//  Created by yozdemir on 29.05.2022.
//

import SwiftUI

struct JoinChatroomModal: View {
    
    @Binding var isOpen: Bool
    @State var joinCode = ""
    @State var newTitle = ""
    @ObservedObject var viewModel = ChatroomsViewModel()
    
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
                            .onChange(of: joinCode) {
                                if $0 == "0" {}
                                if joinCode.count == 6 {
                                    joinCode = String(joinCode.prefix(5))
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
                        }).padding(.trailing, 10)
                    }
                    .padding(.horizontal,5)
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
                            .onChange(of: joinCode) {
                                if $0 == "0" {}
                                if newTitle.count == 31 {
                                    newTitle = String(newTitle.prefix(30))
                                }
                            }
                        Button(action: {
                            UIApplication.shared.endEditing()
                            if newTitle.count >= 5 && newTitle.count <= 30 {
                                viewModel.createChatroom(title: newTitle, handler: {
                                    self.isOpen = false
                                })
                            }
                        }, label: {
                            Image(systemName: "plus.circle")
                                .padding(10)
                                .foregroundColor(.white)
                                .background(Color(hex: 0x608786))
                                .clipShape(Circle())
                        }).padding(.trailing, 10)
                    }
                    .padding(.horizontal,5)
                    .padding(.bottom)
                }
                .padding(.top)
                .padding(.bottom)
            }
            .padding(.bottom, UIWindow.key?.safeAreaInsets.bottom ?? 25 + 10)
            .onTapGesture {
                // Hide Keyboard
                UIApplication.shared.endEditing()
            }
        }
}
