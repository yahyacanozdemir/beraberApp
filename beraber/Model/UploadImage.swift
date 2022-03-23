//
//  UploadImage.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI
import Firebase

func UploadImage(imageData : Data,path: String, completion: @escaping (String) -> ()){
    let storage = Storage.storage().reference()
    let uid = Auth.auth().currentUser!.uid
    
    storage.child(path).child(uid).putData(imageData, metadata: nil) { (_, err) in
        if err != nil {
            completion("")
            return
        }
        
        //URL'i indirme ve arka planda verileri gönderme
        storage.child(path).child(uid).downloadURL { (url,err) in
            if err != nil {
                completion("")
                return
            }
            completion("\(url!)")
        }
            
    }
}
