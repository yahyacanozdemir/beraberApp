//
//  ChatBubble.swift
//  beraber
//
//  Created by yozdemir on 30.05.2022.
//

import SwiftUI

struct ChatBubble: Shape {
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 13, height: 13))
        return Path(path.cgPath)
    }
}

