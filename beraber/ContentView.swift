//
//  ContentView.swift
//  beraber
//
//  Created by yozdemir on 13.03.2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("current_status") var status = false
    var body: some View {
        NavigationView {
            VStack {
                if status{HomeView()}
                else{LoginView()}
            }
            RegisterView()
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
