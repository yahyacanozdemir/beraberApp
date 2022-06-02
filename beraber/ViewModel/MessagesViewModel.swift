//
//  MessagesViewModel.swift
//  beraber
//
//  Created by yozdemir on 29.05.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class MessagesViewModel: ObservableObject {
    
    @Published var messages = [Message]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    @Published var profileData = ProfileViewModel()
    
    func sendMessage(messageContent: String, docId: String) {
        if (user != nil) {
            db.collection("chatrooms").document(docId).collection("messages").addDocument(data: [
                                                                                            "createdTime": Date(),
                                                                                            "senderName": profileData.userInfo.userName,
                                                                                            "senderProfilePic": profileData.userInfo.userProfilePic,
                                                                                            "content": messageContent,
                                                                                            "senderId": user!.uid])
        }
    }
    
    func fetchData(docId: String) {
        if (user != nil) {
            db.collection("chatrooms").document(docId).collection("messages").order(by: "createdTime", descending: false).addSnapshotListener({(snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("no documents")
                    return
                }
                
                self.messages = documents.map { docSnapshot -> Message in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let senderId = data["senderId"] as? String ?? ""
                    let senderName = data["senderName"] as? String ?? ""
                    let senderProfilePic = data["senderProfilePic"] as? String ?? ""
                    let createdTime = data["createdTime"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                    let content = data["content"] as? String ?? ""
                    return Message(id: docId, senderId: senderId, senderName: senderName,senderProfilePic: senderProfilePic , createdTime: createdTime, content: content)
                }
            })
        }
    }
}
