//
//  ChatroomViewModel.swift
//  beraber
//
//  Created by yozdemir on 29.05.2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatroomsViewModel: ObservableObject {
    @Published var chatrooms = [Chatroom]()
    private var db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    @Published var selectedChatRoom: Chatroom = Chatroom(id: "", title: "",creatorUid: "",creatorName: "",createdAt: Timestamp(date: Date(timeIntervalSince1970: 0)), joinCode: -1)

    
    @Published var noChatroom = true
    @Published var isLoading = true
    @Published var createOrJoinProcessLoading = false
    @Published var isJoinCodeValidated = true
    @Published var isRoomTitleValidated = true
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        if user != nil {
            self.isLoading = true
            db.collection("chatrooms").whereField("users", arrayContains: user!.uid).addSnapshotListener { snapShot, error in
                guard let documents = snapShot?.documents else {
                    print("Mesajlar dokumanında geri dönen data yok")
                    return
                }
                self.chatrooms = documents.map({docSnapshot -> Chatroom in
                    let data = docSnapshot.data()
                    let docId = docSnapshot.documentID
                    let title = data["title"] as? String ?? ""
                    let creatorUid = data["creatorUid"] as? String ?? ""
                    let creatorName = data["creatorName"] as? String ?? ""
                    let createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 0))
                    let joinCode = data["joinCode"] as? Int ?? -1
                    return Chatroom(id: docId, title: title,creatorUid: creatorUid,creatorName: creatorName,createdAt: createdAt, joinCode: joinCode)
                })
                
                if self.chatrooms.isEmpty {
                    self.noChatroom = true
                    self.isLoading = false
                } else {
                    self.noChatroom = false
                    self.isLoading = false
                }
            }
        }
    }
    
    func createChatroom(title: String, joinCode: Int = 0, postOwnerId: String = "", handler: @escaping () -> Void){
        
        if user != nil && title != "" && title.count >= 5 && title.count < 30{
            self.createOrJoinProcessLoading = true
            fetchUser(uid: user!.uid) { currentUser in
                self.db.collection("chatrooms").addDocument(data: [
                    "title" : title,
                    "joinCode": joinCode == 0 ? Int.random(in: 10000..<99999) : joinCode,
    //                "users": ["\(user!.uid) +ODADA+"]]) { error in
                    "creatorUid" : self.user!.uid,
                    "creatorName" : currentUser.userName,
                    "createdAt" : Date(),
                    "users": postOwnerId == "" ? [self.user!.uid] : [self.user!.uid, postOwnerId]]) { error in
                        if error != nil {
                            print("Chatroom Eklenirken Hata")
                            self.createOrJoinProcessLoading = false
                        } else {
                            handler()
                            self.createOrJoinProcessLoading = false
                        }
                    }
            }
        }
    }
    
    
    func joinChatroom(code: String, handler: @escaping () -> Void){
        if user != nil {
            self.createOrJoinProcessLoading = true
            fetchUser(uid: user!.uid) { currentUser in
                self.db.collection("chatrooms").whereField("joinCode", isEqualTo: Int(code) ?? -1).getDocuments { snapShot, error in
                    if snapShot?.documents.count == 0 {
                        self.isJoinCodeValidated = false
                        self.createOrJoinProcessLoading = false
                    }
                    if error != nil {
                        self.createOrJoinProcessLoading = false
                        print("Odaya katılma esnasında hata meydana geldi hata: ", error?.localizedDescription ?? "")
                    } else {
                        for document in snapShot!.documents {
                            self.db.collection("chatrooms").document(document.documentID).updateData(["users" :FieldValue.arrayUnion([self.user!.uid])])
    //                        self.db.collection("chatrooms").document(document.documentID).updateData(["users" :FieldValue.arrayUnion(["\(self.user!.uid)" + " +ODADA+"])])
                            handler()
                            self.createOrJoinProcessLoading = false
                        }
                    }
                }
            }
        }
    }
    
    func leaveChatRoom(code: String, handler: @escaping () -> Void){
        if user != nil {
            isLoading = true
            fetchUser(uid: user!.uid) { currentUser in
                self.db.collection("chatrooms").whereField("joinCode", isEqualTo: Int(code) ?? -1).getDocuments { snapShot, error in
                    if error != nil {
                        print(error?.localizedDescription ?? "")
                    } else {
                        for document in snapShot!.documents {
                            self.db.collection("chatrooms").document(document.documentID).updateData(["users" : FieldValue.arrayRemove([self.user!.uid])])
    //                        self.db.collection("chatrooms").document(document.documentID).updateData(["users" : FieldValue.arrayUnion(["\(self.user!.uid)" + " -AYRILDI-"])])
                            handler()
                            self.isLoading = false
                        }
                    }
                    self.isLoading = false
                }
            }
        }
    }
}
