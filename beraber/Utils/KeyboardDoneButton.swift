//
//  KeyboardDoneButton.swift
//  beraber
//
//  Created by yozdemir on 10.04.2022.
//

import SwiftUI

struct TextfieldWithDoneButton: UIViewRepresentable {
    @Binding var text: String
    var keyType: UIKeyboardType
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField()
      textfield.keyboardType = keyType
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textfield.frame.size.width, height: 44))
        let doneButton = UIBarButtonItem(title: "Tamamlandı", style: .done, target: self, action: #selector(textfield.doneButtonTapped(button:)))
        toolBar.items = [doneButton]
        toolBar.setItems([doneButton], animated: true)
        textfield.inputAccessoryView = toolBar
        return textfield
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
    }
}

extension  UITextField{
    @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
       self.resignFirstResponder()
    }

}
