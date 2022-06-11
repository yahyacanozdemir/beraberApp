//
//  NewPostView.swift
//  beraber
//
//  Created by yozdemir on 9.04.2022.
//

import SwiftUI

struct NewPostView: View {
    
    @StateObject var newPostData = NewPostViewModel()
    @Environment(\.presentationMode) var present
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack{
            HStack(spacing: 15){
                VStack(spacing: 5) {
                    if (isTextFieldFocused) {
                        Button(action: {isTextFieldFocused = false}) {
                            Text("Tamamla")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            present.wrappedValue.dismiss()
                        }) {
                            Text("Vazgeç")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                Spacer(minLength: 0)
                
                //Yeni paylaşımlar
                Button(action: {
                    newPostData.picker.toggle()
                }) {
                    Image(systemName: "photo.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    newPostData.post(present: present)
                }) {
                    Text("Paylaş")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical,10)
                        .padding(.horizontal, 25)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                .opacity(newPostData.postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newPostData.postTitle.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                .disabled(newPostData.postText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || newPostData.postTitle.trimmingCharacters(in: .whitespaces).isEmpty ? true : false)
                
                
            }
            .padding()
            .opacity(newPostData.isPosting ? 0.5 : 1)
            .disabled(newPostData.isPosting ? true : false)
            
            TextField("", text: $newPostData.postTitle)
                .placeholder(when: newPostData.postTitle.isEmpty) {
                    Text("Gönderi başlığı").foregroundColor(.white.opacity(0.4))
                }
                .padding()
                .background(.white.opacity(0.6))
                .cornerRadius(15)
                .focused($isTextFieldFocused)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .lineLimit(1)
                .onChange(of: newPostData.postTitle) {
                    if $0 == "0" {}
                    if newPostData.postTitle.count == 40 {
                        newPostData.postTitle = String(newPostData.postTitle.prefix(39))
                    }
                }.padding(.horizontal, 12)
                .padding(.bottom, 5)

            VStack{
                HStack {
                    Text("Gönderiye ait mesaj odası oluştur")
                        .font(.caption)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        Spacer(minLength: 0)
                    Toggle("", isOn: $newPostData.hasChatRoom)
                        .labelsHidden()
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 5)
            
            TextEditor(text: $newPostData.postText)
                .placeholder(when: newPostData.postText == "", alignment: .topLeading, placeholder: {
                    Text("Bir şeyler yaz...")
                        .padding(9)
                })
                .cornerRadius(15)
                .padding()
                .focused($isTextFieldFocused)
                .background(Color.blue)
                .opacity(newPostData.isPosting ? 0.2 : 0.5)
                .foregroundColor(.white)
                .disabled(newPostData.isPosting ? true : false)
            
            if(newPostData.img_data.count != 0) {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    Image(uiImage: UIImage(data: newPostData.img_data)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.screenWidth / 2, height: 150)
                        .cornerRadius(15)
                    
                    Button {
                        newPostData.img_data = Data(count: 0)
                    } label: {
                            Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(15)
                            .background(.blue)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .opacity(newPostData.isPosting ? 0.5 : 1)
                .disabled(newPostData.isPosting ? true : false)
            }
            
        }
        .background(.black)
        .sheet(isPresented: $newPostData.picker) {
            ImagePicker(picker: $newPostData.picker, img_data: $newPostData.img_data)
        }

    }
}
