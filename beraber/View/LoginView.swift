//
//  LoginView.swift
//  beraber
//
//  Created by yozdemir on 13.03.2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginData = LoginViewModel()
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center) {
                
                HStack {
                    Spacer(minLength: 0)
                    Text("Giriş Yap")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        Spacer(minLength: 0)
                }
                .padding()
                .padding(.top,10)
                
                //Telefon Numarası
                VStack {
                    HStack {
                        Text("Telefon Numarası")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer(minLength: 0)
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))

                    HStack{
                        TextField("+90", text: $loginData.code)
                            .padding()
                            .frame(width: 75)
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                            .keyboardType(.phonePad)
                        TextField("5323272005", text: $loginData.number)
                            .padding()
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                            .keyboardType(.numberPad)
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                }
                if loginData.isLoading {
                    ProgressView()
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                } else {
                    HStack {
                        Button(action: loginData.verifyUser) {
                            Text("Giriş Yap")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width-100)
                                .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                        }
                        .background(.blue)
                        .cornerRadius(15)
                    }
                }
                Spacer(minLength: 0)
            }
        }
        .background(Color(hex: 0x465D8B))
        .alert(isPresented: $loginData.error, content: {
            Alert(title: Text("Hata"), message: Text(loginData.errorMsg), dismissButton: .destructive(Text("Tamam")))
        })
        .fullScreenCover(isPresented: $loginData.registerUser, content: {
          RegisterView()
        })
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


