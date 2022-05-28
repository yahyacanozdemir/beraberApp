//
//  SubsettingsView.swift
//  beraber
//
//  Created by yozdemir on 23.05.2022.
//

import SwiftUI
import ExytePopupView
import PartialSheet

struct SubsettingsView: View {
    @StateObject var profileData = ProfileViewModel()
    @StateObject var settingsData = SettingsViewModel()
    @StateObject var citiesData = ReadCityData()
    @Binding var showSubSettings: Bool
    @Binding var showSetings: Bool
    @Binding var subSetting: SettingsViewModel.SubSettings
    @Binding var isUpdatedProfile: Bool
    
    @State var showAgeSheet = false
    @State var showCitySheet = false
    @State var showCountieSheet = false
    @State var showSuccesPopup = false
    
    var edges = UIWindow.key?.safeAreaInsets
    
    var body: some View {
        VStack {
            BeraberNavigationView(title: self.subSetting.rawValue, withTrailingIcon: false, trailingIconName: "", trailingIconCompletion: { value in
                showSubSettings = !value
            }, isForSettings: true, isForSubsettings: true)
            
            ScrollView{
                VStack(alignment: .leading) {
                    
                    //Hesap
                    if subSetting == .account {
                        //Telefon Numarası
                        VStack (alignment: .leading) {
                            Text("Telefon Numarası")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            HStack{
                                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center), content: {
                                    TextField("(90) \(settingsData.userInfo.phoneNumber)", text: .constant(""))
                                        .padding()
                                        .background(.white.opacity(0.6))
                                        .foregroundColor(.black)
                                        .cornerRadius(15)
                                        .disabled(true)
                                    Image(systemName: "lock")
                                        .padding(.trailing, 10)
                                        .foregroundColor(.black)
                                })
                                Spacer(minLength: 0)
                            }
                            
                            Divider()
                        }
                        .padding(.horizontal,20)
                        .padding(.top, 20)
                        
                        //İsim Soyisim
                        VStack (alignment: .leading) {
                            Text("İsim Soyisim")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            HStack{
                                TextField("", text: $settingsData.userInfo.userName)
                                    .placeholder(when: settingsData.userInfo.userName.isEmpty) {
                                        Text("İsim Soyisim").foregroundColor(.white.opacity(0.4))
                                    }
                                    .padding()
                                    .background(.white.opacity(0.6))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .keyboardType(.alphabet)
                                    .disableAutocorrection(true)
                                    .onChange(of: settingsData.userInfo.userName) {
                                        if $0 == "0" {}
                                        if settingsData.userInfo.userName.count == 20 {
                                            settingsData.userInfo.userName = String(settingsData.userInfo.userName.prefix(19))
                                        }
                                    }
                                Spacer(minLength: 0)
                            }
                            
                            Divider()
                        }
                        .padding(.horizontal,20)
                        .padding(.top, 20)
                        
                        // Yaş
                        VStack(alignment: .leading) {
                            Text("Yaş")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            
                            HStack{
                                Spacer(minLength: 0)
                                Button {
                                    showAgeSheet = true
                                } label: {
                                    Text("\(settingsData.userInfo.userAge)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width-40)
                                        .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                                        .cornerRadius(15)
                                }
                                Spacer(minLength: 0)
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.top, 10)
                        
                        //Konum
                        VStack(alignment: .leading) {
                            Text("Konum")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            HStack{
                                Button {
                                    UIApplication.shared.endEditing()
                                    showCitySheet = true
                                } label: {
                                    Text("\(settingsData.newCity)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width/2.3)
                                        .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                                        .cornerRadius(15)
                                        .onChange(of: settingsData.newCity) {newValue in

                                        }
                                }
                                
                                Button {
                                    UIApplication.shared.endEditing()
                                    showCountieSheet = true
                                } label: {
                                    Text("\(settingsData.newCountie)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width/2.3)
                                        .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                                        .cornerRadius(15)
                                }
                                Spacer(minLength: 0)
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.top, 10)
                        
                        //Use Case
                        VStack(alignment: .leading) {
                            Text("Beraber'i Kullanma Amacı")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            HStack{
                                Picker("Kullanım Amacı", selection: $settingsData.useCase) {
                                    ForEach(RegisterViewModel.AppUseCases.allCases) { useCase in
                                        Text(useCase.rawValue.capitalized)
                                            .foregroundColor(.white)
                                            .tag(useCase)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                                .cornerRadius(5)
                            }
                        }
                        .padding(.horizontal,20)
                        .padding(.top, 20)
                    }
                    
                    //Hakkında
                    if subSetting == .biography {
                        //Hakkında
                        VStack {
                            HStack{
                                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                                    if settingsData.userInfo.userBiography.isEmpty {
                                        Text("Hakkında").foregroundColor(Color(UIColor.systemGray2))
                                            .padding()
                                    }
                                    
                                    TextEditor(text: $settingsData.userInfo.userBiography)
                                        .lineLimit(10)
                                        .frame(height: 400)
                                        .padding(.leading, 10)
                                        .padding(.top, 8)
                                        .background(.white.opacity(0.6))
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                        .keyboardType(.asciiCapable)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 20, trailing: 20))
                        }.padding(.top, 20)
                    }
                    
                    //Gizlilik
                    if subSetting == .privacy {
                        
                        //Connection Info
                        VStack {
                            HStack {
                                Text("İletişim Bilgilerimi Diğer Kullanıcılar İle Paylaş")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer(minLength: 0)
                                Toggle("", isOn: $settingsData.userInfo.showConnectionInfos)
                            }
                            .padding(.horizontal, 30)
                        }.padding(.top, 20)
                        
                        //Age Info
                        VStack {
                            HStack {
                                Text("Yaş Bilgimi Profilimde Göster")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer(minLength: 0)
                                Toggle("", isOn: $settingsData.userInfo.showAgeInfos)
                            }
                            .padding(.horizontal, 30)
                        }.padding(.top, 20)
                        
                        //Location Info
                        VStack {
                            HStack {
                                Text("Konum Bilgimi Profilimde Göster")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer(minLength: 0)
                                Toggle("", isOn: $settingsData.userInfo.showLocationInfos)
                            }
                            .padding(.horizontal, 30)
                        }.padding(.top, 20)

                    }
                    
                    //Güvenlik
                    if subSetting == .security {
                        //E-mail
                        VStack (alignment: .leading) {
                            Text("E-Mail Adresi")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            HStack{
                                TextField("", text: $settingsData.userInfo.emailAddress)
                                    .placeholder(when: settingsData.userInfo.userName.isEmpty) {
                                        Text("E-mail").foregroundColor(.white.opacity(0.4))
                                    }
                                    .padding()
                                    .background(.white.opacity(0.6))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .keyboardType(.emailAddress)
                                    .disableAutocorrection(true)
                                    .overlay(RoundedRectangle(cornerRadius: 15).strokeBorder(settingsData.isEmailValidated ? Color.black : Color.red, style: StrokeStyle(lineWidth: 1)))
                                    .onChange(of: settingsData.userInfo.emailAddress) {
                                        if $0 == "0" {}
                                        if settingsData.textFieldValidatorEmail(settingsData.userInfo.emailAddress) {
                                            settingsData.isEmailValidated = true
                                        } else {
                                            settingsData.isEmailValidated = false
                                        }
                                    }
                                Spacer(minLength: 0)
                            }
                            
                            Divider()
                        }
                        .padding(.horizontal,20)
                        .padding(.top, 20)
                    }
                    //Yardım
                    if subSetting == .help {
                        
                    }
                    //Uygulama Bilgileri
                    if subSetting == .app {
                        
                    }
                    
                    //Save Button
                    if subSetting == .account || subSetting == .privacy || subSetting == .security || subSetting == .biography {
                        HStack {
                            Spacer(minLength: 0)
                            Button {
                                if subSetting == .account {
                                    UIApplication.shared.endEditing()
                                    settingsData.updateMyAccount()
                                } else if subSetting == .biography {
                                    settingsData.updateBiography()
                                    UIApplication.shared.endEditing()
                                } else if subSetting == .privacy {
                                    settingsData.updatePrivacy()
                                } else if subSetting == .security {
                                    settingsData.updateSecurity()
                                }
                                
                                showSuccesPopup = true
                                isUpdatedProfile = true
                            } label: {
                                Text("Güncelle")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width-100)
                                    .background(Color(hex: 0x608786))
                            }
                            .background(.blue)
                            .cornerRadius(15)
                            .disabled(settingsData.newCountie == "İlçe")
                            .opacity(settingsData.newCountie == "İlçe" ? 0.5 : 1)
                            .disabled(!settingsData.isEmailValidated)
                            .opacity(settingsData.isEmailValidated ? 1 : 0.5)
                            Spacer(minLength: 0)
                        }
                        .padding(.top, 20)
                    }
                    
                }
            }
        }
        .background(Color(hex: 0x465D8B))
        .transition(.move(edge: .trailing))
        .onAppear(perform: {
            UITextView.appearance().backgroundColor = .clear
        })
        .partialSheet(isPresented: $showAgeSheet) {
            VStack {
                Text("Yaşınız")
                Picker("Yaşınız", selection: $settingsData.userInfo.userAge) {
                    ForEach(15...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            .frame(height: UIScreen.screenHeight/2.5)
            .onDisappear() {
                showAgeSheet = false
            }
        }
        .partialSheet(isPresented: $showCitySheet) {
            VStack {
                Text("Bulunduğunuz Şehir")
                Picker(settingsData.newCity, selection: $settingsData.newCity) {
                    ForEach(citiesData.cities) { city in
                        Text("\(city.name.firstCapitalized)").tag(city.name.firstCapitalized)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            .onDisappear() {
                showCitySheet = false
                if settingsData.newCity != settingsData.userInfo.userLocation.components(separatedBy: ",").first {
                    settingsData.newCountie = "İlçe"
                } else {
                    settingsData.newCountie = settingsData.userInfo.userLocation.components(separatedBy: ",").last ?? ""
                }
            }
        }
        .partialSheet(isPresented: $showCountieSheet) {
            VStack {
                Text("Bulunduğunuz İlçe")
                Picker(settingsData.newCountie, selection: $settingsData.newCountie) {
                    ForEach(citiesData.cities.filter{ settingsData.newCity == $0.name.firstCapitalized}) { city in
                        ForEach(city.counties , id: \.self) { countie in
                            Text("\(countie.firstCapitalized)").tag(countie.firstCapitalized)
                        }
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            .onDisappear() { showCountieSheet = false }
        }
        .popup(isPresented: $showSuccesPopup, type: .toast , position: .top ,autohideIn: 3, closeOnTapOutside: true, dismissCallback: {
            self.showSuccesPopup = false
        }){
            Text(settingsData.succesPopupTitle)
                .fontWeight(.bold)
                .frame(width: 200, height: 40)
                .background(Color(hex: 0x608786))
                .cornerRadius(30.0)
                .padding(.top, UIWindow.key?.safeAreaInsets.top)
                .padding(.horizontal, 20)
        }
        .highPriorityGesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
                    .onEnded { value in
                        if abs(value.translation.height) < abs(value.translation.width) {
                            if abs(value.translation.width) > 50.0 {
                                if value.translation.width > 0 {
                                    self.swipeLeftToRight()
                                }
                            }
                        }
                    }
                )
    }

    func swipeLeftToRight() {
        showSetings = true
        showSubSettings = false
        print("Swiped Left to Right -->")
    }
}
