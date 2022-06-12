//
//  PostViewModel.swift
//  beraber
//
//  Created by yozdemir on 9.04.2022.
//

import SwiftUI
import Firebase

class PostViewModel : ObservableObject {
    @Published var posts: [PostModel] = []
    @Published var noPosts = false
    @Published var newPost = false
    @Published var updateId = ""
    
    @Published var selectedPostImageUrl = ""
    @Published var selectedPostUserUid = ""
    
    @Published var isLoading = false
    
    let ref = Firestore.firestore()
    
//    init() {
//        if self.posts.count == 0 {
//            getAllPosts()
//        }
//    }
    
    func getAllPosts(){
        self.posts = []
        isLoading = true
        ref.collection("Posts").addSnapshotListener { snap, err in
            guard let docs = snap else {
                self.noPosts = true
                self.isLoading = false
                return
            }
            if docs.documentChanges.isEmpty {
                self.noPosts = true
                self.isLoading = false
                return
            }
            docs.documentChanges.forEach { doc in
                //Doc ekli mi kontrolü
                if doc.type == .added {
                    let title = doc.document.data()["title"] as! String
                    let description = doc.document.data()["description"] as! String
                    let time = doc.document.data()["time"] as! Timestamp
                    let pic = doc.document.data()["url"] as! String
                    let hasChatRoom = doc.document.data()["hasChatRoom"] as! Bool
                    let chatRoomTitle = doc.document.data()["chatRoomTitle"] as! String
                    let chatRoomCode = doc.document.data()["chatRoomCode"] as! String
                    let userRef = doc.document.data()["ref"] as! DocumentReference
                    
                    //user bilgilerini çekme
                    fetchUser(uid: userRef.documentID) { user in
                        if self.posts.count < docs.count {
                            self.posts.append(PostModel(id: doc.document.documentID, title: title,description: description, pic: pic, time: time.dateValue(),hasChatroom: hasChatRoom, chatRoomCode: chatRoomCode,chatRoomTitle: chatRoomTitle, user: user))
//                            print("Post Count : ", self.posts.count, " Docs Count: ", docs.count)
                        }
                        //Oluşturma tarihine göre sıralama
                        self.posts.sort{ (p1,p2) -> Bool in
                            return p1.time > p2.time
                        }
                        self.isLoading = false
                    }
                }
            
                if doc.type == .removed {
                    let id = doc.document.documentID
                    self.posts.removeAll() { post -> Bool in
                        return post.id == id
                    }
//                    Profilim sekmesinde kaldırılan posttan sonra loading gözükmesi için yoruma alındı
//                    self.isLoading = false
                }
            }
        }
    }
    
    func updatePost(id: String){
        ref.collection("Posts").document(id).updateData(["hasChatRoom" : true]) { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }
    
    func deletePost(id: String){
        ref.collection("Posts").document(id).delete() { error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
        }
        ref.collection("Posts").addSnapshotListener { snap, err in
            guard let docs = snap else {
                self.noPosts = true
                return
            }
            
            if docs.documentChanges.isEmpty {
                self.noPosts = true
                return
            }
        }
        self.getAllPosts()        
    }
}
