//
//  FetchUser.swift
//  beraber
//
//  Created by yozdemir on 9.04.2022.
//

import SwiftUI
import Firebase


let ref = Firestore.firestore()

func fetchUser(uid: String, completion: @escaping (UserModel)->()){
    ref.collection("Users").document(uid).getDocument { doc, err in
        guard let user = doc else {return}
        
        let userName = user.data()?["name"] as! String
        let userSurname = user.data()?["surname"] as! String
        let userLocation = user.data()?["location"] as! String
        let userProfilePic = user.data()?["imageurl"] as! String
        let uid = user.documentID
        
        DispatchQueue.main.async {
            completion(UserModel(userName: userName, userSurname: userSurname, userLocation: userLocation, userProfilePic: userProfilePic, uid: uid))
        }
    }
}
