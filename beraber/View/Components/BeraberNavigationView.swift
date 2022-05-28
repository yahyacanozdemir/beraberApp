//
//  BeraberNavigationView.swift
//  beraber
//
//  Created by yozdemir on 27.05.2022.
//

import SwiftUI

struct BeraberNavigationView: View {
    var title: String
    var withTrailingIcon: Bool
    var trailingIconName: String = ""
    var trailingIconCompletion: (Bool) -> ()
    var isForSettings: Bool = false
    var isForSubsettings: Bool = false
    var edges = UIWindow.key?.safeAreaInsets
    var body: some View {
        if isForSettings {
            HStack{
                VStack {
                    Text("BERABER")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .padding(.top, -60)
                    HStack{
                        Image(systemName: "arrow.backward")
                            .font(.title)
                            .foregroundColor(.white)
                            .onTapGesture {
                                trailingIconCompletion(true)
                            }
                        Text(self.title)
                            .font(isForSubsettings ? .title : .largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        Spacer(minLength: 0)
                    }
                    .padding(.top,-30)
                }
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
            
        } else {
            HStack{
                VStack {
                    Text("BERABER")
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .padding(.top, -30)
                    HStack{
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        //                        Spacer(minLength: 0).opacity(profileData.isLoading ? 1 : 0)
                        //                        ProgressView().opacity(profileData.isLoading ? 1 : 0)
                        Spacer(minLength: 0)
                        if withTrailingIcon {
                            Button {
                                trailingIconCompletion(true)
                            } label: {
                                Image(systemName: trailingIconName)
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding()
            .padding(.top, edges!.top)
            .background(Color(hex: 0x465D8B))
            .shadow(color: .white.opacity(0.06), radius: 5, x: 0, y: 5)
        }
    }
}

