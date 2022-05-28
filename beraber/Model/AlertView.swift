//
//  AlertView.swift
//  beraber
//
//  Created by yozdemir on 6.04.2022.
//

import SwiftUI

func alertView(msg: String, completion: @escaping (String) -> ()){
    let alert = UIAlertController(title: msg.contains("Doğrulama") ? "Kodu Giriniz" : "Güncelle", message: msg, preferredStyle: .alert)
    alert.addTextField { (txt) in
        txt.placeholder = msg.contains("Doğrulama") ? "123456" : ""
        txt.keyboardType = msg.contains("Doğrulama") ? .numberPad : .default
    }
    alert.addAction(UIAlertAction(title: msg.contains("Doğrulama") ? "Doğrula" : "Bilgilerini Güncelle", style: .default, handler: { (_) in
        let code = alert.textFields![0].text ?? ""
        if code == "" {
            //Repromoting
            UIWindow.key?.rootViewController?.present(alert, animated: true)
            return
        }
        completion(code)
    }))
    alert.addAction(UIAlertAction(title: "Vazgeç", style: .destructive))
    UIWindow.key?.rootViewController?.present(alert, animated: true)
}
