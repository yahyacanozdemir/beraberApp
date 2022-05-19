//
//  OtherProfileViewModel.swift
//  beraber
//
//  Created by yozdemir on 12.05.2022.
//

import SwiftUI
import Firebase

class OtherProfileViewModel: ObservableObject {
    @Published var userInfo = UserModel(uid: "", userProfilePic: "", userName: "", userBiography: "", userAge: 0, userLocation: "", userReasonForApp: "", userCreationDate: Timestamp(date: Date(timeIntervalSince1970: 0)))

    @Published var isLoading = false

    var uid: String = ""
    let ref = Firestore.firestore()
    
    func fetchOtherUser(uid: String){
        self.isLoading = true
        fetchUser(uid: uid) { user in
            self.userInfo = user
            self.isLoading = false
        }
    }
}
