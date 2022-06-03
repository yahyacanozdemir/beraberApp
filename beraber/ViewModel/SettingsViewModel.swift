//
//  SettingsViewModel.swift
//  beraber
//
//  Created by yozdemir on 22.05.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class SettingsViewModel: ObservableObject {
    @Published var userInfo = UserModel(uid: "", userProfilePic: "", userName: "", userBiography: "", userAge: 0, userLocation: "", userReasonForApp: "",phoneNumber: "", emailAddress: "", possibleDaysOfWeek: [], showConnectionInfos: false, showPossibleDaysInfos: false,showAgeInfos: false,showLocationInfos: false, userCreationDate: Timestamp(date: Date(timeIntervalSince1970: 0)))
    @AppStorage("current_status") var status = false
    
    enum SubSettings: String, CaseIterable, Identifiable{
        var id: String { return self.rawValue }
        case account = "Hesap"
        case biography = "Hakkında"
        case privacy = "Gizlilik"
        case security = "Güvenlik"
        case help = "Yardım"
        case app = "Uygulama Bilgileri"
        case none = ""
    }
    @Published var subSetting: SubSettings = .none
    
    enum HelpMailTitleContents: String, CaseIterable, Identifiable{
        var id: String { return self.rawValue }
        case ReportUser = "Kullanıcı Bildirimi"
        case ReportBug = "Hata Bildirimi"
        case AdviceForApp = "Özellik Önerisi"
        case other = "Diğer"
    }
    @Published var helpMailTitleContent: HelpMailTitleContents = .ReportUser
    @Published var helpMailDescContent: String = ""
    @Published var isReadyForSendEmail: Bool = true

    
    @Published var picker = false
    @Published var img_data = Data(count: 0)
    @Published var isLoading = false
    @Published var newCity: String = ""
    @Published var newCountie: String = ""
    @Published var city: String = "Şehir"
    @Published var countie = "İlçe"
    
    
    @Published var useCase = RegisterViewModel.AppUseCases.Hepsi
    @Published var possibleDaysArray : [String] = []

    
    @Published var succesPopupTitle = ""
    @Published var succesPopupColor = Color(hex: 0x608786)

    @Published var isEmailValidated = true
    

    let ref = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid
    
    init(){
        fetchUser(uid: uid) { user in
            self.userInfo = user
            self.newCity = user.userLocation.components(separatedBy: ",").last ?? ""
            self.newCountie = user.userLocation.components(separatedBy: ",").first ?? ""
            let rawValue = user.userReasonForApp.components(separatedBy: ".").last?.components(separatedBy: ")").first ?? ""
            self.useCase = RegisterViewModel.AppUseCases(rawValue: rawValue) ?? .Hepsi
        }
    }
    
    func updateImage(){
        self.isLoading = true
        UploadImage(imageData: img_data, path: "profile_photos") { (url) in
            self.ref.collection("Users").document(self.uid).updateData([
                "imageurl": url,
            ]) { (err) in
                if err != nil {return}
                //Update view
                self.isLoading = false
                fetchUser(uid: self.uid) { user in
                    self.userInfo = user
                }
            }
        }
    }
    
    func updateMyAccount(){
        self.succesPopupTitle = "Bilgiler Güncellendi"
        self.updateUserDetailsFirebase(id: "name", value: self.userInfo.userName)
        self.updateUserDetailsFirebase(id: "location", value: self.newCountie+","+self.newCity)
        self.updateUserDetailsFirebase(id: "reasonForApp", value: "\(self.useCase.rawValue)")
        self.updateUserDetailsFirebase(id: "age", value: (self.userInfo.userAge))
        self.updateUserDetailsFirebase(id: "possibleDaysOfWeek", value: (self.possibleDaysArray))
    }
    
    func updateBiography(){
        self.succesPopupTitle = "Hakkında Güncellendi"
        self.updateUserDetailsFirebase(id: "biography", value: self.userInfo.userBiography)
    }
    
    func updatePrivacy(){
        self.succesPopupTitle = "Ayarlar Güncellendi"
        self.updateUserDetailsFirebase(id: "showConnectionInfos", value: self.userInfo.showConnectionInfos)
        self.updateUserDetailsFirebase(id: "showPossibleDaysInfos", value: self.userInfo.showPossibleDaysInfos)
        self.updateUserDetailsFirebase(id: "showAgeInfos", value: self.userInfo.showAgeInfos)
        self.updateUserDetailsFirebase(id: "showLocationInfos", value: self.userInfo.showLocationInfos)
    }
    
    func updateSecurity(){
        self.succesPopupTitle = "E-Mail Güncellendi"
        self.updateUserDetailsFirebase(id: "emailAddress", value: self.userInfo.emailAddress)
    }
    
    func updateUserDetailsFirebase(id : String, value : Any){
        ref.collection("Users").document(uid).updateData([
            id : value,
        ]) { err in
            if err != nil {return}
            fetchUser(uid: self.uid) { user in
                self.userInfo = user
            }
        }
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    func prepareMailContent() -> [String : String]{
        let mailDict = ["Subject" : "\"Beraber\" " + self.helpMailTitleContent.rawValue,
                        
                        "Content" : "\(self.helpMailDescContent)"
                        + "\n\n\(self.userInfo.userName)"
                        + "\n(0)\(self.userInfo.phoneNumber)",
                        
                        "Recipients" : "yahyacanozdemir@gmail.com",
                        "PreferredSendingEmail" : self.userInfo.emailAddress]
        return mailDict
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
    
    func logOut(){
        try! Auth.auth().signOut()
        status = false
    }
}
