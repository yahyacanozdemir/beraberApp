//
//  NewPostViewModel.swift
//  beraber
//
//  Created by yozdemir on 9.04.2022.
//

import SwiftUI
import Firebase

class NewPostViewModel : ObservableObject {
    @Published var postTitle = ""
    @Published var postText = ""
    @Published var hasChatRoom = true
    @Published var chatRoomCode = ""
    @Published var picker = false
    @Published var img_data = Data(count: 0)
    @ObservedObject var chatRoomViewModel = ChatroomsViewModel()
        
   @Published var isPosting = false
    
    let uid = Auth.auth().currentUser!.uid
    
    func post(present: Binding<PresentationMode>){
        
        isPosting = true
        
        if img_data.count == 0 {
            self.chatRoomCode = String(Int.random(in: 10000..<99999))
            ref.collection("Posts").document().setData([
                "title" : self.postTitle,
                "description" : self.postText,
                "url" : "",
                "ref" : ref.collection("Users").document(self.uid),
                "hasChatRoom": self.hasChatRoom,
                "chatRoomTitle": self.postTitle,
                "chatRoomCode": self.chatRoomCode,
                "time" : Date()
                
            ]) { error in
                if error != nil {
                    self.isPosting = false
                    print("Resimsiz Post Paylaşmada Hata: ", error?.localizedDescription ?? "")
                    return
                } else {
                    self.isPosting = false
                    present.wrappedValue.dismiss()
                }
            }
        } else {
            UploadImage(imageData: img_data
                        , path:"post_pics") { URL in
                ref.collection("Posts").document().setData([
                
                    "title" : self.postTitle,
                    "description" : self.postText,
                    "url" : URL,
                    "ref" : ref.collection("Users").document(self.uid),
                    "hasChatRoom": self.hasChatRoom,
                    "chatRoomTitle": self.postTitle,
                    "chatRoomCode": self.chatRoomCode,
                    "time" : Date()
                    
                ]) { error in
                    if error != nil {
                        self.isPosting = false
                        return
                    } else {
                        self.isPosting = false
                        present.wrappedValue.dismiss()
                    }
                }
            }
        }
        if hasChatRoom {
            chatRoomViewModel.createChatroom(title: postTitle,joinCode: Int(chatRoomCode) ?? 0) {}
        }
    }
}

