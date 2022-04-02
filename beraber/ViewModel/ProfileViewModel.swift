//
//  ProfileViewModel.swift
//  beraber
//
//  Created by yozdemir on 3.04.2022.
//

import SwiftUI
import Firebase


class ProfileViewModel : ObservableObject{
    @Published var userInfo = UserModel(userName: "", userSurname: "", userLocation: "" , userProfilePic: "")
    @AppStorage("current_status") var status = false
    
    let ref = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    init(){
        fetchUser()
    }
    
    func fetchUser(){
        ref.collection("Users").document(uid).getDocument { doc, err in
            guard let user = doc else {return}
            
            let userName = user.data()?["name"] as! String
            let userSurname = user.data()?["surname"] as! String
            let userLocation = user.data()?["location"] as! String
            let userProfilePic = user.data()?["imageurl"] as! String
            
            DispatchQueue.main.async {
                self.userInfo = UserModel(userName: userName, userSurname: userSurname, userLocation: userLocation, userProfilePic: userProfilePic)
            }
        }
    }
    
    func logOut(){
        try! Auth.auth().signOut()
        status = false
    }
}

