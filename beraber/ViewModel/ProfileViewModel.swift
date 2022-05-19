//
//  ProfileViewModel.swift
//  beraber
//
//  Created by yozdemir on 3.04.2022.
//

import SwiftUI
import Firebase


class ProfileViewModel : ObservableObject{
    @Published var userInfo = UserModel(uid: "", userProfilePic: "", userName: "", userBiography: "", userAge: 0, userLocation: "", userReasonForApp: "", userCreationDate: Timestamp(date: Date(timeIntervalSince1970: 0)))
    @AppStorage("current_status") var status = false
    
    @Published var picker = false
    @Published var img_data = Data(count: 0)
    
    @Published var isLoading = false
    
//    @StateObject var postData = PostViewModel()

    
//    let formatter = DateFormatter()

    
    let ref = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    init(){
        fetchUser(uid: uid) { user in
            self.userInfo = user
        }
    }
    
//    func getCreationDateAsString(date: Date)-> String{
//        formatter.dateFormat = "d MMM y"
//        return formatter.string(from: date)
//    }
    
    func updateImage(){
        self.isLoading = true
        UploadImage(imageData: img_data, path: "profile_photos") { (url) in
            self.ref.collection("Users").document(self.uid).updateData([
                "imageurl": url,
            ]) { (err) in
                if err != nil {return}
                //Update view
                self.isLoading = false
                fetchUser(uid: self.uid) { user in
                    self.userInfo = user
                }
            }
        }
    }
    
    func updateUserDetails(field: String){
        alertView(msg: "Aşağıdaki kutucuğa yeni bilgilerini girebilirsin.") { txt in
            if txt != "" {
                self.updateUserDetailsFirebase(id: field == "name" ? "name" : "location" , value: txt)
            }
        }
    }
    
    func updateUserDetailsFirebase(id : String, value : String){
        ref.collection("Users").document(uid).updateData([
            id : value,
        ]) { err in
            if err != nil {return}
            fetchUser(uid: self.uid) { user in
                self.userInfo = user
            }
        }
    }
    
//    func userHasAnyPost() -> Bool{
//        for post in postData.posts {
//            if post.user.uid == uid {
//            return true
//            }
//        }
//        return false
//    }
    
    func logOut(){
        try! Auth.auth().signOut()
        status = false
    }
}

