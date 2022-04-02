//
//  PostView.swift
//  beraber
//
//  Created by yozdemir on 2.04.2022.
//

import SwiftUI

struct PostView: View {
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    var body: some View {
        VStack{
            HStack{
                Text("Anasayfa")
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
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
            Spacer(minLength: 0)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
