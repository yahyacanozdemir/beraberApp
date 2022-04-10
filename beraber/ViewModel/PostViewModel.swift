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
    
    let ref = Firestore.firestore()
    
    init() {
        getAllPosts()
    }
    
    func getAllPosts(){
        ref.collection("Posts").addSnapshotListener { snap, err in
            guard let docs = snap else {
                self.noPosts = true
                return
            }
            
            if docs.documentChanges.isEmpty {
                self.noPosts = true
                return
            }
            docs.documentChanges.forEach { doc in
                //Doc ekli mi kontrolü
                if doc.type == .added {
                    let title = doc.document.data()["title"] as! String
                    let time = doc.document.data()["time"] as! Timestamp
                    let pic = doc.document.data()["url"] as! String
                    let userRef = doc.document.data()["ref"] as! DocumentReference
                    
                    //user bilgilerini çekme
                    fetchUser(uid: userRef.documentID) { user in
                        self.posts.append(PostModel(id: doc.document.documentID, title: title, pic: pic, time: time.dateValue(), user: user))
                        
                        //Oluşturma tarihine göre sıralama
                        self.posts.sort{ (p1,p2) -> Bool in
                            return p1.time > p2.time
                        }
                    }
                }
            
                if doc.type == .removed {
                    let id = doc.document.documentID
                    
                    self.posts.removeAll() { post -> Bool in
                        return post.id == id
                    }
                }
                
                if doc.type == .modified {
                    
                    print("Güncelleme Başarılı")
                    //Doc'u güncelleme
                    
                    let id = doc.document.documentID
                    let title = doc.document.data()["title"] as! String
                    
                    let index = self.posts.firstIndex { post in
                        return post.id == id
                    } ?? -1
                    
                    //safe check
                    if index != -1{
                        self.posts[index].title = title
                        self.updateId = ""
                    }
                    
                }
            }
        }
    }
    
    func deletePost(id: String){
        
        ref.collection("Posts").document(id).delete() { error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
        }
        
    }
    
    func editPost(id: String){
        updateId = id
        //Düzenleme ekranını gösterme
        newPost.toggle()
    }
    
}
