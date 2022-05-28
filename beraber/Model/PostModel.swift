//
//  PostModel.swift
//  beraber
//
//  Created by yozdemir on 9.04.2022.
//

import SwiftUI

struct  PostModel : Identifiable {
    var id: String
    var title: String
    var description: String
    var pic: String
    var time: Date
    var user: UserModel
}
