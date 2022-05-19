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
    @Published var biography = ""
    @Published var city: String = "Şehir"
    @Published var countie = "İlçe"
    
    @Published var image_data = Data(count: 0)
    @Published var picker = false
    
    @Published var showAgeSheet = false
    @Published var age: Int = 18

    
    
    enum AppUseCases: String, CaseIterable, Identifiable {
        case Bildiriciyim = "Duyurucu"
        case Hepsi = "İkisi de"
        case Bağışçıyım = "Bağışçı"

        var id: String { self.rawValue }
    }
    
    @Published var useCase = AppUseCases.Hepsi
    
    
    
    let ref = Firestore.firestore()
    
    @Published var isLoading = false
    @AppStorage("current_status") var status = false


    func register(){
        let reasonForApp = useCase == .Hepsi ? "İkisi de" : useCase == .Bildiriciyim ? "Duyurucu" : "Bağışçı"
        isLoading = true
        let uid = Auth.auth().currentUser!.uid
        UploadImage(imageData: image_data, path: "profile_photos") { (url) in
            self.ref.collection("Users").document(uid).setData([
                
                "uid": uid,
                "imageurl": url,
                "name": self.name,
                "biography": self.biography,
                "location": "\(self.countie),\(self.city)",
                "age": self.age,
                "reasonForApp": reasonForApp,
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
