//
//  RegisterView.swift
//  beraber
//
//  Created by yozdemir on 24.03.2022.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var registerData = RegisterViewModel()
    @StateObject var citiesData = ReadCityData()
    
    @ObservedObject var keyboard = KeyboardResponder()
    @FocusState var isFocused: Bool
    
    @State var showAgeSheet = false
    @State var showCitySheet = false
    @State var showCountieSheet = false
        
    func checkCityName(cityName: String) -> Bool{
        return cityName.firstCapitalized == registerData.city ? true : false
    }
    
    //Text Editor'e bg vermek için gerekli
    init() { UITextView.appearance().backgroundColor = .clear }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hoşgeldin!")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    Text("Hızlıca profilini oluşturup beraber'lik akımına hemen dahil olabilirsin.")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Divider()
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .padding(.top,10)
            
            
            //Profil Fotoğrafı
            HStack {
                Spacer(minLength: 0)
                ZStack {
                    if registerData.image_data.count == 0 {
                        Image(systemName: "person.crop.circle.fill.badge.plus")
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
                .onTapGesture {
                    registerData.picker.toggle()
                }
                Spacer(minLength: 0)
            }.padding()
            
            //İsim Soyisim
            VStack {
                HStack{
                    TextField("", text: $registerData.name)
                        .placeholder(when: registerData.name.isEmpty) {
                            Text("İsim Soyisim").foregroundColor(.white.opacity(0.4))
                        }
                        .padding()
                        .background(.white.opacity(0.6))
                        .cornerRadius(15)
                        .focused($isFocused)
                        .keyboardType(.alphabet)
                        .disableAutocorrection(true)
                        .onChange(of: registerData.name) {
                            if $0 == "0" {}
                            if registerData.name.count == 20 {
                                registerData.name = String(registerData.name.prefix(19))
                            }
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
                    Spacer(minLength: 0)
                }
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 10, trailing: 20))
            }
            
            //Hakkında
            VStack {
                HStack{
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                        if registerData.biography.isEmpty {
                            Text("Hakkında").foregroundColor(Color(UIColor.systemGray2))
                                .padding()
                        }
                        
                        TextEditor(text: $registerData.biography)
                            .lineLimit(10)
                            .frame(height: 100)
                            .padding(.leading, 10)
                            .padding(.top, 8)
                            .background(.white.opacity(0.6))
                            .cornerRadius(15)
                            .focused($isFocused)
                            .keyboardType(.asciiCapable)
                            .onTapGesture(perform: {
                                
                            })
//                            .onChange(of: registerData.biography) {
//                                if $0 == "0" {}
//                                if registerData.biography.count == 300 {
//                                    registerData.biography = String(registerData.biography.prefix(299))
//                                }
//                            }
                    }
                    

                    Spacer(minLength: 0)
                }
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 20, trailing: 20))
            }
            
            // Lokasyon
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    Text("Konum")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.6))
                    Spacer(minLength: 0)
                }
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                HStack{
                    Button {
                        showCitySheet = true
                    } label: {
                        Text("\(registerData.city)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width/2.3)
                            .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                            .cornerRadius(15)
                            .onChange(of: registerData.city) { newValue in
                                    registerData.countie = "İlçe"
                            }
                    }
                    
                    Button {
                        showCountieSheet = true
                    } label: {
                        Text("\(registerData.countie)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width/2.3)
                            .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                            .cornerRadius(15)
                    }
                    .opacity(registerData.city == "Şehir" ? 0.5 : 1 )
                    .disabled(registerData.city == "Şehir" ? true : false)
                    
                    Spacer(minLength: 0)
                }
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 15, trailing: 20))
            }
            
            // Yaş
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    Text("Yaş")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.6))
                    Spacer(minLength: 0)
                }
                .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 0, trailing: 20))
                
                HStack{
                    Spacer(minLength: 0)
                    Button {
                        showAgeSheet = true
                    } label: {
                        Text("\(registerData.age)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width-40)
                            .background(Color(red: 12/255, green: 115/255, blue: 178/255))
                            .cornerRadius(15)
                    }
                    Spacer(minLength: 0)
                }
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 30, trailing: 20))
            }
            
            //UseCase
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    Text("Beraber'i Kullanma Amacı")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.6))
                    Spacer(minLength: 0)
                }
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                HStack{
                    Picker("Kullanım Amacı", selection: $registerData.useCase) {
                        ForEach(RegisterViewModel.AppUseCases.allCases) { useCase in
                            Text(useCase.rawValue.capitalized)
                                .tag(useCase)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
            
            //ConnectionInfos
            VStack {
                Divider()
                    .padding(.bottom, 10)
                
                Text("İletişim Bilgileri")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center), content: {
                    TextField("(90) \(registerData.phoneNumber)", text: .constant(""))
                        .padding()
                        .background(.white.opacity(0.6))
                        .cornerRadius(15)
                        .disabled(true)
//                        .multilineTextAlignment(.center)
                    Image(systemName: "lock")
                        .padding(.trailing, 10)
                        .foregroundColor(.black)
                })
                    .padding(.horizontal, 30)
                
                HStack{
                    TextField("", text: $registerData.eMail)
                        .placeholder(when: registerData.eMail.isEmpty) {
                            Text("E-posta adresi").foregroundColor(.white.opacity(0.4))
                        }
                        .padding()
                        .background(.white.opacity(0.6))
                        .cornerRadius(15)
                        .focused($isFocused)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .overlay(RoundedRectangle(cornerRadius: 15).strokeBorder(registerData.isEmailValidated ? Color.black : Color.red, style: StrokeStyle(lineWidth: 1)))
                        .onChange(of: registerData.eMail) {
                            if $0 == "0" {}
                            if self.registerData.textFieldValidatorEmail(registerData.eMail) {
                                registerData.isEmailValidated = true
                            } else {
                                registerData.isEmailValidated = false
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                HStack {
                                    Button("Kapat") {
                                        isFocused = false
                                    }
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                }
                .padding(.horizontal, 30)
                
                
                Text("Diğer kullanıcıların seninle iletişime geçebileceği müsait günlerini seç")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(alignment: .center)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .trailing){
                    ForEach(RegisterViewModel.daysOfWeek.allCases, id: \.rawValue){ day in
                        CheckboxField(
                            id: day.rawValue,
                            label: day.rawValue,
                            size: 14,
                            textSize: 14,
                            callback: registerData.checkboxSelected
                        )
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                
                HStack {
                    Text("İletişim bilgilerimi profilimde göster")
                        .foregroundColor(.white)
                        .font(.caption)
                    Spacer(minLength: 0)
                    Toggle("", isOn: $registerData.showMyConnectionInfos)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)

            }

            Divider()
                .padding(.bottom, 10)
            
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
                    .disabled(registerData.validateRegister() ? false : true)
                    .opacity(registerData.validateRegister() ? 1.0 : 0.5)
                    .cornerRadius(15)
                }
            }
//            Spacer(minLength: 0)
        }
        .background(.black)
        .padding(10)
        .partialSheet(isPresented: $showAgeSheet) {
            VStack {
                Text("Yaşınız")
                Picker("Yaşınız", selection: $registerData.age) {
                    ForEach(15...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            .frame(height: .infinity)
            .onDisappear() {
                showAgeSheet = false
            }
        }
        .partialSheet(isPresented: $showCitySheet) {
            VStack {
                Text("Bulunduğunuz Şehir")
                Picker("Şehir", selection: $registerData.city) {
                    ForEach(citiesData.cities) { city in
                        Text("\(city.name.firstCapitalized)").tag(city.name.firstCapitalized)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            .frame(height: .infinity)
            .onDisappear() {
                showCitySheet = false
            }
        }
        .partialSheet(isPresented: $showCountieSheet) {
            VStack {
                Text("Bulunduğunuz İlçe")
                Picker("İlçe", selection: $registerData.countie) {
                    ForEach(citiesData.cities.filter{ registerData.city == $0.name.firstCapitalized}) { city in
                        ForEach(city.counties as! [String], id: \.self) { countie in
                            Text("\(countie.firstCapitalized)").tag(countie.firstCapitalized)
                        }
                    }
                }.pickerStyle(WheelPickerStyle())
            }
            .frame(height: .infinity)
            .onDisappear() { showCountieSheet = false }
        }
        .sheet(isPresented: $registerData.picker, content: {
            ImagePicker(picker: $registerData.picker, img_data: $registerData.image_data)
        })
        .attachPartialSheetToRoot()
    }
}

