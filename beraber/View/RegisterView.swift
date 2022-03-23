//
//  RegisterView.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var registerData = RegisterViewModel()
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                HStack {
                    Spacer(minLength: 0)
                    Text("Kayıt Ol")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        Spacer(minLength: 0)
                }
                .padding()
                .padding(.top,10)
                
                
                ZStack {
                    
                    if registerData.image_data.count == 0 {
                        Image(systemName: "person")
                            .font(.system(size: 65))
                            .foregroundColor(.black)
                            .frame(width: 115, height: 115)
                            .background(.white)
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: UIImage(data: registerData.image_data)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 115, height: 115)
                            .clipShape(Circle())
                    }
                }
                .padding(.top)
                .onTapGesture {
                    registerData.picker.toggle()
                }

                
                //İsim Soyisim
                VStack {
                    HStack {
                        Text("İsim Soyisim")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer(minLength: 0)
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))

                    HStack{
                        TextField("İsim", text: $registerData.name)
                            .padding()
                            .frame(width: UIScreen.screenWidth / 2.5)
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                        TextField("Soyisim", text: $registerData.surname)
                            .padding()
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                }
                
                //Lokasyon
                VStack {
                    HStack {
                        Text("Bulunduğunuz Şehir")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer(minLength: 0)
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))

                    HStack{
                        TextField("Şehir", text: $registerData.location)
                            .padding()
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                }

                if registerData.isLoading {
                    ProgressView()
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                } else {
                    HStack {
                        Button(action: registerData.register) {
                            Text("Kayıt Oluştur")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width-100)
                                .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                        }
//                        .disabled(registerData.image_data.count == 0 || registerData.name == "" || registerData.surname == "" || registerData.location == "" ? true : false)
//                        .opacity(registerData.image_data.count == 0 || registerData.name == "" || registerData.surname == "" ||  registerData.location == "" ? 0.5 : 1)
                        .disabled(registerData.name == "" || registerData.surname == "" || registerData.location == "" ? true : false)
                        .opacity(registerData.name == "" || registerData.surname == "" ||  registerData.location == "" ? 0.5 : 1)
                        .cornerRadius(15)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .background(Color(hex: 0x465D8B))
        .sheet(isPresented: $registerData.picker, content: {
            ImagePicker(picker: $registerData.picker, img_data: $registerData.image_data)
        })
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
