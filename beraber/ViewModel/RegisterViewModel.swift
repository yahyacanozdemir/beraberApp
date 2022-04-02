//
//  RegisterViewModel.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI
import Firebase

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var surname = ""
    @Published var location = ""
    
    @Published var image_data = Data(count: 0)
    @Published var picker = false
    let ref = Firestore.firestore()
    
    @Published var isLoading = false
    @AppStorage("current_status") var status = false

    func register(){
        isLoading = true
        let uid = Auth.auth().currentUser!.uid
        UploadImage(imageData: image_data, path: "profile_photos") { (url) in
            self.ref.collection("Users").document(uid).setData([
                
                "uid": uid,
                "name": self.name,
                "surname": self.surname,
                "imageurl": url,
                "location": self.location,
                "created_date": Date()

                
                ]) { (err) in
                if err != nil {
                    self.isLoading = false
                    return
                }
                self.isLoading = false
                self.status = true
            }
        }
    }
    
}
