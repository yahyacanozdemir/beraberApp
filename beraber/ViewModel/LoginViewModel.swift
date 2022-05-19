//
//  LoginViewModel.swift
//  beraber
//
//  Created by yozdemir on 13.03.2022.
//

import SwiftUI
import Firebase

class LoginViewModel : ObservableObject {
    @Published var code = "+90"
    @Published var number = ""
    
    
    //Error Handle
    @Published var errorMsg = ""
    @Published var error = false
    
    @Published var registerUser = false
    @AppStorage("current_status") var status: Bool = false
    
    @Published var isLoading = false
    
    @Published var isVerificationCodeAreaShowing = false
    @Published var verificationCode = ""
    
    func verifyUser(){
        
        self.isLoading = true
        //Test Aşaması için gerekli
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        let phoneNumber = code + number
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { ID, err in
            
            // Hata var ise
            if err != nil  {
                self.errorMsg = err!.localizedDescription
                self.error.toggle()
                self.isLoading = false
                return
            }
            // Hata Yok ise
            
            self.isVerificationCodeAreaShowing = true
            
            if self.verificationCode == "" {
                self.isLoading = false
                return
            } else {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: ID!, verificationCode: self.verificationCode)
                Auth.auth().signIn(with: credential) { res, err in
                    if err != nil  {
                        self.errorMsg = err!.localizedDescription
                        self.error.toggle()
                        self.isLoading = false
                        return
                    }
                    self.isLoading = false
                    self.checkUser()
                }
            }
            

        }
    }
    
    func checkUser(){
        let ref = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        ref.collection("Users").whereField("uid", isEqualTo: uid).getDocuments { (snap, err) in
            if err != nil {
                // Documents Yok veya Kullanıcı Bulunamadı
                self.registerUser.toggle()
                self.isLoading = false
                return
            }
            
            if snap!.documents.isEmpty {
                self.registerUser.toggle()
                self.isLoading = false
                return
            }
            self.isLoading = false
            self.status = true
            print("Kullanıcı Doğrulandı...")
        }
    }
    
//    func prepareNumberForTurkey() -> String {
//        
//        
//        if self.number.first == "0" {
//            number.remove(at: number.startIndex)
//        }
//        
//        let phoneNumber = code + number
//        
//        return phoneNumber
//    }
}
