//
//  MessageModel.swift
//  beraber
//
//  Created by yozdemir on 29.05.2022.
//

import Foundation
import Firebase

struct Message: Identifiable {
    var id: String?
    var senderId: String?
    var senderName: String
    var senderProfilePic: String
    var createdTime: Timestamp
    var content: String
}
