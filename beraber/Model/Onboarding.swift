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
    Onboarding(image: "OB1", title: "Hoşgeldin", description: "Amacımız, önce yaşadığımız bölgenin, daha sonra tüm insanlığın refah seviyesini arttırmak. \n\nUnutma ki yaşadığımız mahallede, ilçede, şehirde, ülke ve yer küre üzerinde Beraber'iz.", color: Color(hex: 0xf05a66)),
    Onboarding(image: "OB2", title: "Yardıma Muhtaç", description: "Artık yakın çevrende bulunan maddi ya da manevi durumu kötü olan yardıma muhtaç insanlar için onları incitmeyecek paylaşımlarda bulunabilirsin. \n\nUnutma ki herhangi bir çaba göstermessek onlarla Beraber hepimiz zarar göreceğiz.", color: Color(hex: 0xcf856c)),
    Onboarding(image: "OB3", title: "Yardımsever", description: "Aramızda bulunan iyilik telaşlılarından biriysen gördüğün paylaşımlarla harekete geçebilir, ihtiyaç sahibi kişilerin yardımına koşabilirsin. \n\nHerzaman Beraber olmamız gerektiğini, asıl zenginliğin gönül zenginliği olduğunu unutma.", color: Color(hex: 0x7d8264)),
    Onboarding(image: "blue_logo", title: "Beraber", description: "Bundan sonra hep Beraber'iz. Yeter ki inanalım birbirimize, çok daha güzeliz.", color: Color(hex: 0x0aa1dc))
    

]
