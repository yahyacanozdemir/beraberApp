//
//  CitiesModel.swift
//  beraber
//
//  Created by yozdemir on 10.04.2022.
//

import SwiftUI

struct CitiesModel: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case name
        case plate
        case counties
    }
    
    var id = UUID()
    var name: String
    var plate: String
    var counties: Array<String>
}
