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
        
        let uid = user.documentID
        let userProfilePic = user.data()?["imageurl"] as! String
        let userName = user.data()?["name"] as! String
        let bio = user.data()?["biography"] as! String
        let age = user.data()?["age"] as! Int
        let userLocation = user.data()?["location"] as! String
        let reasonForApp = user.data()?["reasonForApp"] as! String
        let phoneNumber = user.data()?["phoneNumber"] as! String
        let emailAddress = user.data()?["emailAddress"] as! String
        let possibleDaysOfWeek = user.data()?["possibleDaysOfWeek"] as! [String]
        let showAgeInfos = user.data()?["showAgeInfos"] as! Bool
        let showConnectionInfos = user.data()?["showConnectionInfos"] as! Bool
        let showLocationInfos = user.data()?["showLocationInfos"] as! Bool
        let userCreationDate = user.data()?["created_date"] as! Timestamp
        
        DispatchQueue.main.async {
            completion(UserModel(uid: uid,
                                 userProfilePic: userProfilePic,
                                 userName: userName,
                                 userBiography:bio,
                                 userAge: age,
                                 userLocation: userLocation,
                                 userReasonForApp: reasonForApp,
                                 phoneNumber: phoneNumber,
                                 emailAddress: emailAddress,
                                 possibleDaysOfWeek: possibleDaysOfWeek,
                                 showConnectionInfos: showConnectionInfos,
                                 showAgeInfos: showAgeInfos,
                                 showLocationInfos: showLocationInfos,
                                 userCreationDate: userCreationDate))
        }
    }
}
