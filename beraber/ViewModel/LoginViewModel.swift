//
//  LoginViewModel.swift
//  beraber
//
//  Created by yozdemir on 13.03.2022.
//

import SwiftUI
import Firebase

class LoginViewModel : ObservableObject {
    @Published var code = ""
    @Published var number = ""
    
    //Error Handle
    @Published var errorMsg = ""
    @Published var error = false
    
    @Published var registerUser = false
    @AppStorage("current_status") var status: Bool = false
    
    @Published var isLoading = false
    
    func verifyUser(){
        
        self.isLoading = true
        //Test Aşaması için gerekli
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        let phoneNumber = "+" + code + number
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { ID, err in
            
            // Hata var ise
            if err != nil  {
                self.errorMsg = err!.localizedDescription
                self.error.toggle()
                self.isLoading = false
                return
            }
            // Hata Yok ise
            self.alertView { (code) in
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: ID!, verificationCode: code)
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
    
    func alertView(completion: @escaping (String) -> ()){
        let alert = UIAlertController(title: "Doğrulama", message: "Kodu Giriniz", preferredStyle: .alert)
        alert.addTextField { (txt) in
            txt.placeholder = "123456"
            txt.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .destructive, handler: { (_) in
            self.isLoading = false
        }))
        alert.addAction(UIAlertAction(title: "Doğrula", style: .default, handler: { (_) in
            let code = alert.textFields![0].text ?? ""
            if code == "" {
                //Repromoting
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                return
            }
            self.isLoading = false
            completion(code)
        }))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func checkUser(){
        let ref = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        ref.collection("Users").whereField("uid", arrayContains: uid).getDocuments {
            (snap, err) in
            if err != nil {
                // Documents Yok veya Kullanıcı Bulunamadı
                self.registerUser.toggle()
                self.isLoading = false
                return
            }
            
            if snap!.documents.isEmpty {
                self.registerUser.toggle()
                self.isLoading = false
                return
            }
            self.isLoading = false
            self.status = true
            print("Kullanıcı Doğrulandı...")
        }
    }
}
