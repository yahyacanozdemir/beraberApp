//
//  ContentView.swift
//  beraber
//
//  Created by yozdemir on 13.03.2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("current_status") var status = false
    @State var skipOnboarding = false

    var body: some View {
        
        if !skipOnboarding {
            GeometryReader { proxy in
                let size = proxy.size
                OnboardingView(skipOnboarding: $skipOnboarding, screenSize: size)
                    .preferredColorScheme(.dark)
            } .animation(.easeInOut)
        } else {
            NavigationView {
                VStack {
                    if status{HomeView()}
                    else{LoginView()}
                }
                RegisterView()
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
            }.animation(.easeInOut)
        }
        

        
//        GeometryReader { proxy in
//            let size = proxy.size
//            OnboardingView(screenSize: size)
//                .preferredColorScheme(.dark)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
