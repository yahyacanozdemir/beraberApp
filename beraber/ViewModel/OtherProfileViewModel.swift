//
//  OtherProfileViewModel.swift
//  beraber
//
//  Created by yozdemir on 12.05.2022.
//

import SwiftUI
import Firebase

class OtherProfileViewModel: ObservableObject {
    @Published var userInfo = UserModel(uid: "", userProfilePic: "", userName: "", userBiography: "", userAge: 0, userLocation: "", userReasonForApp: "",phoneNumber: "", emailAddress: "", possibleDaysOfWeek: [], showConnectionInfos: false, showPossibleDaysInfos: false, showAgeInfos: false,showLocationInfos: false, numberOfRooms: 0, userCreationDate: Timestamp(date: Date(timeIntervalSince1970: 0)))

    @Published var isLoading = false
    @Published var openUserConnectionInfos = false
    @Published var showUserImage: Bool = false
    @Published var showPostImage: Bool = false
    
    @State var profileImgUrl: String = ""
    @State var postImgUrl: String = ""


    var uid: String = ""
    let ref = Firestore.firestore()
    
    func fetchOtherUser(uid: String){
        self.isLoading = true
        fetchUser(uid: uid) { user in
            self.userInfo = user
            self.isLoading = false
            self.profileImgUrl = user.userProfilePic
        }
    }
    
    func phoneNumberParser(number: String) -> String{
        
        let index = number.index(number.startIndex, offsetBy: 3)
        let index2 = number.index(index, offsetBy: 3)
        let index3 = number.index(index2, offsetBy: 2)
        let index4 = number.index(index3, offsetBy: 2)
        
        let part1 = "(0) \(number.substring(to: index))"
        let part2 = number[index ..< index2]
        let part3 = number[index2 ..< index3]
        let part4 = number[index3 ..< index4]

        return "\(part1)"+" \(part2)"+" \(part3)"+" \(part4)"
    }
}
