//
//  LoginView.swift
//  beraber
//
//  Created by yozdemir on 13.03.2022.
//

import SwiftUI
import PartialSheet

struct LoginView: View {
    @State private var timeRemaining = 1
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @StateObject var loginData = LoginViewModel()
    @State var showLoginFields = false
        
    @ObservedObject private var keyboard = KeyboardResponder()
    @FocusState private var isFocused: Bool

    
    var body: some View {
        VStack {
            
            Image(uiImage: UIImage(named: "AppLogo")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 350, height: 350, alignment: .center)
                .padding(.top, showLoginFields ? -30: UIScreen.screenHeight / 6.0)
                .animation(showLoginFields ? .linear : .none)
                .opacity(isFocused ? 0 : 1)
            
            VStack(alignment: .center) {
                HStack {
                    Text("Giriş Yap")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.leading, 5)
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
                            .foregroundColor(.black.opacity(0.7))
                            .padding()
                            .frame(width: 75)
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                            .keyboardType(.phonePad)
                            .focused($isFocused)
                            .disabled(true)
                        
                        TextField("", text: $loginData.number)
                            .placeholder(when: loginData.number.isEmpty) {
                                Text("5323272005").foregroundColor(.black.opacity(0.4))
                            }
                            .lineLimit(1)
                            .foregroundColor(.black.opacity(0.7))
                            .padding()
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                            .keyboardType(.numberPad)
                            .focused($isFocused)
//                            .disabled(loginData.isLoading ? true : false)
                            .onChange(of: loginData.number) {
                                
                                if $0 == "0" {
                                    loginData.number.remove(at: loginData.number.startIndex)
                                }
                                
                                if loginData.number.count == 11 {
                                    loginData.number = String(loginData.number.prefix(10))
                                }
                                
                                loginData.isVerificationCodeAreaShowing = false
                            }
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    HStack {
                                        Button("Kapat") {
                                            self.isFocused = false
                                        }
                                        Spacer(minLength: 0)
                                    }
                                }
                            }
                    }
                    .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                    
                    
                    if loginData.isVerificationCodeAreaShowing {
                        HStack {
                            Text("Doğrulama Kodu")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.6))
                            Spacer(minLength: 0)
                        }
                        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                        
                        HStack{
                            TextField("", text: $loginData.verificationCode)
                                .placeholder(when: loginData.verificationCode.isEmpty) {
                                    Text("123456").foregroundColor(.black.opacity(0.4))
                                }
                                .foregroundColor(.black.opacity(0.7))
                                .padding()
                                .background(.white.opacity(0.6))
                                .cornerRadius(15)
                                .keyboardType(.phonePad)
                                .frame(width: 130)
                                .focused($isFocused)
//                                .disabled(loginData.isVerificationCodeAreaShowing ? true : false)
                            Spacer(minLength: 0)
                        }
                        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                    }
                }
                
                if loginData.isLoading {
                    ProgressView()
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                } else {
                    HStack {
                        Button(action: loginData.verifyUser) {
                            Text(loginData.isVerificationCodeAreaShowing ? "Giriş Yap" : "Devam et")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.screenWidth / 2)
                                .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                        }
                        .background(.blue)
                        .cornerRadius(15)
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, loginData.isVerificationCodeAreaShowing ? 100 : 0)
                }
                Spacer(minLength: 0)
            }
            .opacity(showLoginFields ? 1.0 : 0.0)
            .animation(showLoginFields ? .linear : .none)
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .background(.black)
        .alert(isPresented: $loginData.error, content: {
            Alert(title: Text("Hata"), message: Text(loginData.errorMsg), dismissButton: .destructive(Text("Tamam")))
        })
        .fullScreenCover(isPresented: $loginData.registerUser, content: {
            RegisterView()
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
        })
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }else{
                self.showLoginFields = true
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


