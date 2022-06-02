//
//  RegisterViewModel.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI
import Firebase

class RegisterViewModel: ObservableObject {
    
//    var shared = RegisterViewModel()
    
    @Published var name = ""
    @Published var biography = ""
    @Published var city: String = "Şehir"
    @Published var countie = "İlçe"
    
    @Published var image_data = Data(count: 0)
    @Published var picker = false
    
    @Published var age: Int = 18
    
    @Published var phoneNumber = UserDefaults.standard.object(forKey: "phoneNumber") as? String ?? ""
    @Published var eMail = ""
    //True olmasının sebebi ilk başta border'ı siyah yapmak. View içerisinde başlangıçta false'a çekiliyor.
    @Published var isEmailValidated = true
    @Published var possibleDaysArray : [String] = []
    @Published var isSelectedPossibleDay = false
    @Published var showMyConnectionInfos = true
    
    enum daysOfWeek: String, CaseIterable, Identifiable {
        var id: String { return self.rawValue }
        case Pazartesi
        case Salı
        case Çarşamba
        case Perşembe
        case Cuma
        case Cumartesi
        case Pazar
    }

    
    
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
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    func checkboxSelected(id: String, isMarked: Bool) {
        print("\(id) is marked: \(isMarked)")
        if isMarked {
            self.possibleDaysArray.append(id)
        } else {
            removeDayFromArray(element: id)
        }
        print("++++", self.possibleDaysArray)
    }
    
    func removeDayFromArray(element: String) {
        self.possibleDaysArray = self.possibleDaysArray.filter { $0 != element }
    }
    
    func validateRegister() -> Bool{
        if self.image_data == Data(count: 0) || self.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self.biography.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self.city == "Şehir" || self.countie == "İlçe" || self.eMail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !self.isEmailValidated || self.possibleDaysArray.count == 0  {
            return false
        } else {
            return true
        }
    }

    func register(){
        let reasonForApp = self.useCase.rawValue
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
                "phoneNumber": self.phoneNumber,
                "emailAddress": self.eMail,
                "possibleDaysOfWeek": self.possibleDaysArray,
                "showConnectionInfos": self.showMyConnectionInfos,
                "showLocationInfos": true,
                "showAgeInfos": false,
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
