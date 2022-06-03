//
//  SubsettingsView.swift
//  beraber
//
//  Created by yozdemir on 23.05.2022.
//

import SwiftUI
import ExytePopupView
import PartialSheet
import MessageUI

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
    @State var showEmailTitleContents = false
    
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    
    var edges = UIWindow.key?.safeAreaInsets
    
    var body: some View {
        VStack {
            BeraberNavigationView(title: self.subSetting.rawValue, withTrailingIcon: false, trailingIconName: "", trailingIconCompletion: { value in
                showSubSettings = !value
            }, isForSettings: true, isForSubsettings: true)
            
            ScrollView(showsIndicators: false){
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
                        
                        //PossibleDays
                        VStack(alignment: .leading){
                            Text("Müsait Olduğun Günler")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                            Text("Bu bilgilerin diğer kullanıcılarla paylaşımını gizlilik ayarlarından kontrol edebilirsin. ")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.vertical, 0.5)
                                .frame(alignment: .center)
                            
                            VStack(alignment: .trailing){
                                ForEach(RegisterViewModel.daysOfWeek.allCases, id: \.rawValue){ day in
                                    CheckboxField(
                                        id: day.rawValue,
                                        label: settingsData.userInfo.possibleDaysOfWeek.contains(day.rawValue) ? "\(day.rawValue) (Seçili)" : day.rawValue,
                                        size: 14,
                                        textSize: 14,
                                        callback: settingsData.checkboxSelected
                                    )
                                }
                            }
                            .padding(.vertical, 10)
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
                                Text("İletişim Bilgilerimi Diğer Kullanıcılar İle Paylaş (Telefon Numarası ve E-Mail)")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer(minLength: 0)
                                Toggle("", isOn: $settingsData.userInfo.showConnectionInfos)
                            }
                            .padding(.horizontal, 30)
                        }.padding(.top, 20)
                        Divider()
                            .background(.white)
                            .padding(.top, 10)
                        VStack {
                            HStack {
                                Text("Müsait Olduğum Günleri Diğer Kullanıcılar İle Paylaş")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer(minLength: 0)
                                Toggle("", isOn: $settingsData.userInfo.showPossibleDaysInfos)
                            }
                            .padding(.horizontal, 30)
                        }.padding(.top, 20)
                        Divider()
                            .background(.white)
                            .padding(.top, 10)
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
                        Divider()
                            .background(.white)
                            .padding(.top, 10)
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
                                    .overlay(RoundedRectangle(cornerRadius: 15).strokeBorder(settingsData.isEmailValidated ? .gray.opacity(0.4) : Color.red, style: StrokeStyle(lineWidth: 1)))
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
                            
                            Text("Hesabının güvenliğini sağlamak amacıyla yukarıda girmiş olduğun e-mail adresi kullanılmaktadır. Ek olarak kaydettiğin e-mail adresi, gizlilik tercihlerine göre diğer kullanıcılar ile paylaşılacaktır.")
                                .foregroundColor(.white)
                                .font(.caption)
                                .fontWeight(.thin)
                                .padding(.horizontal, 5)
                            }
                        .padding(.horizontal,20)
                        .padding(.top, 20)
                    }
                    
                    //Yardım
                    if subSetting == .help {
                        VStack {
                            VStack (alignment: .leading){
                                VStack(alignment: .leading){
                                    Text("Bize Ulaş")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("Herhangi bir konuda yardıma ihtiyacın var ise aşağıdaki alanları doldurarak bize ulaşabilirsin.")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .fontWeight(.thin)
                                }
                                .padding(.horizontal,20)
                                .padding(.top, 10)

                                VStack(alignment: .leading) {
                                    Text("Başlık")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                    
                                    HStack{
                                        Spacer(minLength: 0)
                                        Button {
                                            showEmailTitleContents = true
                                        } label: {
                                            Text("\(settingsData.helpMailTitleContent.rawValue) 🔽")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .padding(.vertical)
                                                .padding(.leading, 10)
                                                .frame(width: UIScreen.main.bounds.width-40, alignment: .leading)
                                                .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                                                .cornerRadius(15)
                                        }
                                        Spacer(minLength: 0)
                                    }
                                }
                                .padding(.horizontal,20)
                                .padding(.top, 20)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("İçerik")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.horizontal,20)
                                HStack{
                                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                                        if settingsData.helpMailDescContent.isEmpty {
                                            Text("Mail İçeriği").foregroundColor(.white)
                                                .padding()
                                        }
                                        
                                        TextEditor(text: $settingsData.helpMailDescContent)
                                            .lineLimit(10)
                                            .frame(height: 400)
                                            .padding(.leading, 10)
                                            .padding(.top, 8)
                                            .background(.white.opacity(0.6))
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                            .keyboardType(.asciiCapable)
                                            .onChange(of: settingsData.helpMailDescContent) { text in
                                                settingsData.isReadyForSendEmail = text.count > 20
                                            }
                                    }
                                    Spacer(minLength: 0)
                                }
                                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 10, trailing: 20))
                            }
                            .onAppear(perform: {
                                settingsData.isReadyForSendEmail = false
                            })
                            .padding(.top, 10)
                        }
                    }
                    
                    //Uygulama Bilgileri
                    if subSetting == .app {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("AppLogo")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .cornerRadius(60)
                                    .aspectRatio(contentMode: .fill)
                                    .padding(.leading, 20)
                                    .padding(.top, 10)
                                    .padding(.bottom, 2)
                                
                                Spacer(minLength: 0)
                                
                                VStack (alignment: .trailing){
                                    AppSettingsDevelopmentInfosCell(title: "Piyasaya Sürülme Tarihi", info: "24 Haziran 2022")
                                        .padding(.top, 2)
                                        .padding(.bottom, 0.2)
                                    AppSettingsDevelopmentInfosCell(title: "Geliştirici", info: "Yahya Can Özdemir")
                                        .padding(.vertical, 0.2)
                                    AppSettingsDevelopmentInfosCell(title: "Versiyon", info: "1.0")
                                }
                                .padding(.leading, 1)
                                .padding(.trailing, 20)
                            }
                                   
                            Text("Amacımız")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 2)
                            
                            Text("Beraber uygulamasını geliştirirken tek bir amacımız vardı. Bu amacımızı misyonumuz ve ismimiz olarak belirledik. Uygulamayı geliştirirken tamamen iyilik akımına odaklanarak hiçbir kar amacı gütmedik. Birbirimizin yardımına koşmamız gerektiğini, her an yardıma ihtiyacı olan kişinin biz olabileceğimizi unutmadık; unutulsun istemedik.\n\nDaha güçlü, refah seviyesi daha yüksek bir toplumun temellerini atanlardan olmak istiyor, bu amacın gerçekleşmesi için topluma beraberlik akımı başlatacak bir uygulamayı tamamen ücretsiz olarak sunuyoruz. Amacımız halkımızın mutluluğu!")
                                .foregroundColor(.white)
                                .font(.caption)
                                .fontWeight(.thin)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                            
                            Text("Kullanım Şekli")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 2)
                            
                            Text("Uygulamayı kullanmaya kendine bir amaç belirleyerek başlayabilirsin. Amaç belirlerken; çevrendeki yardıma ihtiyacı olan insanları bildiren DUYURUCU, yardıma ihtiyacı olan kişi ya da kişilere yardım etmek isteyen BAĞIŞÇI, veya duruma göre ikisini de gerçekleştirmek isteyen DUYURUCU & BAĞIŞÇI tiplerinden birini seçebilirsin. \n\nAmacını ve profilini doğru bir şekilde oluşturup izinlerini belirledikten sonra paylaşımlarında ve mesajlaşmalarında güven sağlayabilirsin. Uygulamada özellikle Duyurucu tipinde paylaşımlar yaparken karşı tarafı incitmediğine emin olmalısın. Bağışçı tipindeki paylaşımlarda ise fevri hareketlerde ya da sahte paylaşımlarda bulunarak beraberlik akımına zarar vermemelisin.\n\nGönderilere ait mesaj odalarında sadece gönderi hakkında konuşmalar gerçekleştirilmelidir. Herhangi bir değere, kişiye, kurum ya da kuruluşa karşı küfürlü ve hakeret içeren yazışmalar tespit edildiği taktirde suçun sana ait olduğunu unutmamalısın.")
                                .foregroundColor(.white)
                                .font(.caption)
                                .fontWeight(.thin)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                            
                        }
                    }
                    
                    //Save Button
                    if subSetting != .app{
                        HStack {
                            Spacer(minLength: 0)
                            Button {
                                if subSetting == .account {
                                    UIApplication.shared.endEditing()
                                    settingsData.updateMyAccount()
                                } else if subSetting == .biography {
                                    UIApplication.shared.endEditing()
                                    settingsData.updateBiography()
                                } else if subSetting == .privacy {
                                    settingsData.updatePrivacy()
                                } else if subSetting == .security {
                                    settingsData.updateSecurity()
                                } else if subSetting == .help {
                                    UIApplication.shared.endEditing()
                                    isShowingMailView = true
                                }
                                
                                showSuccesPopup = subSetting != .help
                                isUpdatedProfile = subSetting != .help
                            } label: {
                                Text(subSetting == .help ? "Mail Gönder" : "Güncelle")
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
                            .opacity(settingsData.isReadyForSendEmail ? 1 : 0.5)
                            .disabled(!settingsData.isReadyForSendEmail)
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
        .partialSheet(isPresented: $showEmailTitleContents) {
            VStack {
                Text("Konu Başlığı")
                Picker("Başlık", selection: $settingsData.helpMailTitleContent) {
                    ForEach(SettingsViewModel.HelpMailTitleContents.allCases, id: \.self) { title in
                        Text(title.rawValue)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            .frame(height: UIScreen.screenHeight/2.5)
            .onDisappear() {
                showEmailTitleContents = false
            }
        }
        .sheet(isPresented: $isShowingMailView, onDismiss: {
            switch result {
            case .success(_):
                print("succes")
                settingsData.succesPopupTitle = "Mail Gönderildi"
                settingsData.helpMailDescContent = ""
                showSuccesPopup = true
            case .failure(_):
                print("error")
                settingsData.succesPopupColor = Color(hex: 0xd36d59)
                settingsData.succesPopupTitle = "Bir Hata Oluştu."
                showSuccesPopup = true
            case .none:
                print("none")
            }
        }) {
            MailView(result: $result) { composer in
                composer.setSubject(settingsData.prepareMailContent()["Subject"] ?? "")
                composer.setMessageBody(settingsData.prepareMailContent()["Content"] ?? "", isHTML: false)
                composer.setToRecipients([settingsData.prepareMailContent()["Recipients"] ?? ""])
                composer.setPreferredSendingEmailAddress(settingsData.prepareMailContent()["PreferredSendingEmail"] ?? "")
            }
        }
        .popup(isPresented: $showSuccesPopup, type: .toast , position: .top ,autohideIn: 3, closeOnTapOutside: true, dismissCallback: {
            self.showSuccesPopup = false
        }){
            Text(settingsData.succesPopupTitle)
                .fontWeight(.bold)
                .frame(width: 200, height: 40)
                .foregroundColor(.white)
                .background(settingsData.succesPopupColor)
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
    }
}

struct AppSettingsDevelopmentInfosCell: View {
    var title: String
    var info: String
    var body: some View {
        VStack(alignment: .trailing) {
            Text("\(title)")
                .font(.custom("", size: 16))
                .foregroundColor(.white.opacity(0.65))
                .fontWeight(.thin)
                .fixedSize()
            Text(info)
                .font(.custom("", size: 16))
                .foregroundColor(.white.opacity(0.85))
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(Text.TruncationMode.head)
                .minimumScaleFactor(0.5)
        }
    }
}
