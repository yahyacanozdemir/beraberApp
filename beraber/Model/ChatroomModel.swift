//
//  ChatroomModel.swift
//  beraber
//
//  Created by yozdemir on 29.05.2022.
//

import Foundation
import Firebase

struct Chatroom: Identifiable {
    var id: String
    var title: String
    var creatorUid: String
    var creatorName: String
    var createdAt: Timestamp
    var joinCode: Int
}
