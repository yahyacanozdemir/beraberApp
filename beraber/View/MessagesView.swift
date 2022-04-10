//
//  MessagesView.swift
//  beraber
//
//  Created by yozdemir on 3.04.2022.
//

import SwiftUI

struct MessagesView: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    var body: some View {
        VStack{
            HStack{
                VStack {
                    Text("BERABER")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.top, -30)
                    HStack{
                        Text("Mesajlar")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        Spacer(minLength: 0)
                        
                        Button(action:{}){
                            Image(systemName: "square.and.pencil")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            Spacer(minLength: 0)
        }
        .padding(18)
    }
}
