//
//  MessagesView.swift
//  beraber
//
//  Created by yozdemir on 3.04.2022.
//

import SwiftUI

struct MessagesView: View {
    @Binding var tabSelection: String
    var edges = UIWindow.key?.safeAreaInsets
    var body: some View {
        VStack{
            BeraberNavigationView(title: "Mesajlar", withTrailingIcon: true, trailingIconName: "square.and.pencil") { _ in }
            Spacer(minLength: 0)
        }
        .padding(18)
    }
}
