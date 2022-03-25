//
//  Onboarding.swift
//  beraber
//
//  Created by yozdemir on 25.03.2022.
//

import SwiftUI

struct Onboarding: Identifiable {
    var id = UUID().uuidString
    var image: String
    var title: String
    var description: String
    var color: Color
}

var pages : [Onboarding] = [
    Onboarding(image: "blue_logo", title: "BERABER'E Hoşgeldin", description: "Burada amacımız fgfdsgsdfg sdfgsdfgsd dsfgsdgfsd", color: Color(hex: 0x465D8B)),
    Onboarding(image: "komsu_bildirimi", title: "Kişi Bildirimi", description: "Yardıma ihtiyacı olduğunu düşündüğün bir arkadaşın, komşun ya da tanıdığın var ise bunu uygulamada paylaşabilirsin.", color: .yellow),
    Onboarding(image: "yardimlasma", title: "Birlikten Güç Doğar.", description: "Burada amacımız fgfdsgsdfg sdfgsdfgsd dsfgsdgfsd", color: Color(hex: 0x465D8B))
    

]
