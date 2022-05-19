//
//  UserModel.swift
//  beraber
//
//  Created by yozdemir on 3.04.2022.
//

import SwiftUI
import Firebase

struct UserModel {
    var uid : String
    var userProfilePic : String//    var userSurname : String
    var userName : String
    var userBiography : String
    var userAge: Int
    var userLocation : String
    var userReasonForApp : String
    var userCreationDate: Timestamp
}

