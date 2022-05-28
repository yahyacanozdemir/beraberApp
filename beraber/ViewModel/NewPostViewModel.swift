//
//  NewPostViewModel.swift
//  beraber
//
//  Created by yozdemir on 9.04.2022.
//

import SwiftUI
import Firebase

class NewPostViewModel : ObservableObject {
    @Published var postTitle = ""
    @Published var postText = ""
    @Published var picker = false
    @Published var img_data = Data(count: 0)
    
   @Published var isPosting = false
    
    let uid = Auth.auth().currentUser!.uid
    
    func post(updateId: String, present: Binding<PresentationMode>){
        
        isPosting = true
        
//        if updateId != "" {
//            ref.collection("Posts").document(updateId).updateData([
//
//                "title": postText
//            ]) { error in
//
//                self.isPosting = false
//                if error != nil {
//                    self.isPosting = false
//                    print(error?.localizedDescription)
//                    return
//                }
//                present.wrappedValue.dismiss()
//            }
//            return
//        }
        
        if img_data.count == 0 {
            ref.collection("Posts").document().setData([
            
                "title" : self.postTitle,
                "description" : self.postText,
                "url" : "",
                "ref" : ref.collection("Users").document(self.uid),
                "time" : Date()
                
            ]) { error in
                if error != nil {
                    self.isPosting = false
                    return
                }
                self.isPosting = false
                present.wrappedValue.dismiss()
            }
        } else {
            UploadImage(imageData: img_data
                        , path:"post_pics") { URL in
                ref.collection("Posts").document().setData([
                
                    "title" : self.postTitle,
                    "description" : self.postText,
                    "url" : URL,
                    "ref" : ref.collection("Users").document(self.uid),
                    "time" : Date()
                    
                ]) { error in
                    if error != nil {
                        self.isPosting = false
                        return
                    }
                    self.isPosting = false
                    present.wrappedValue.dismiss()
                }
            }
        }
        

        
    }
}

