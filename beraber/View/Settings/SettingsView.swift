//
//  SettingsView.swift
//  beraber
//
//  Created by yozdemir on 22.05.2022.
//

import SwiftUI
import PartialSheet


struct SettingsView: View {
    @StateObject var settingsData = SettingsViewModel()
    
    @Binding var openBiography: Bool
    @Binding var openSettings: Bool
    @Binding var isUpdatedProfile: Bool
    @State var openSubSettingsView = false
    
    var body: some View {
        VStack {
            if settingsData.isLoading {
                ProgressView()
            } else {
                BeraberNavigationView(title: "Ayarlar", withTrailingIcon: false, trailingIconName: "", trailingIconCompletion: { value in
                    openSettings = !value
                }, isForSettings: true, isForSubsettings: false)
                ScrollView{
                    VStack(alignment: .leading) {
                        
                        //Hesap
                        Button {
                            openSubSettingsView.toggle()
                            settingsData.subSetting = .account
                        } label: {
                            SettingsCell(iconName: "person.circle", iconTitle: SettingsViewModel.SubSettings.account.rawValue)
                        }
                        //Hakkında
                        Button {
                            openSubSettingsView.toggle()
                            settingsData.subSetting = .biography
                        } label: {
                            SettingsCell(iconName: "text.book.closed", iconTitle: SettingsViewModel.SubSettings.biography.rawValue)
                        }
                        //Gizlilik
                        Button {
                            openSubSettingsView.toggle()
                            settingsData.subSetting = .privacy
                        } label: {
                            SettingsCell(iconName: "lock.shield", iconTitle: SettingsViewModel.SubSettings.privacy.rawValue)
                        }
                        //Güvenlik
                        Button {
                            openSubSettingsView.toggle()
                            settingsData.subSetting = .security
                        } label: {
                            SettingsCell(iconName: "checkmark.shield", iconTitle: SettingsViewModel.SubSettings.security.rawValue)
                        }
                        //Yardım
                        Button {
                            openSubSettingsView.toggle()
                            settingsData.subSetting = .help
                        } label: {
                            SettingsCell(iconName: "questionmark.circle", iconTitle: SettingsViewModel.SubSettings.help.rawValue)
                        }
                        //Uygulama Bilgileri
                        Button {
                            openSubSettingsView.toggle()
                            settingsData.subSetting = .app
                        } label: {
                            SettingsCell(iconName: "info.circle", iconTitle: SettingsViewModel.SubSettings.app.rawValue)
                        }
                    }
                    
                    //LogoutButton
                    HStack {
                        Button(action: settingsData.logOut) {
                            Text("Çıkış Yap")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width-100)
                                .background(Color(red: 211/255, green: 109/255, blue: 89/255))
                        }
                        .background(.blue)
                        .cornerRadius(15)
                    }
                    .padding(.bottom, 60)
                    
                    //                Spacer(minLength: 0)
                }
            }
        }
        .onAppear(perform: {
            settingsData.subSetting = openBiography ? .biography : .none
            openSubSettingsView = openBiography
            openBiography = false
        })
        .overlay(openSubSettingsView ? SubsettingsView(showSubSettings: $openSubSettingsView, showSetings: self.$openSettings, subSetting: $settingsData.subSetting, isUpdatedProfile: self.$isUpdatedProfile).onDisappear(perform: {
            settingsData.subSetting = .none
        }) : nil)
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
        .background(Color(hex: 0x465D8B))
        .attachPartialSheetToRoot()
    }
    func swipeLeftToRight() {
        openSettings = settingsData.subSetting == .none ?  false : true
        openSubSettingsView = settingsData.subSetting == .none ?  true : false
    }
}

struct SettingsCell: View {
    var iconName: String
    var iconTitle: String
    var body: some View {
        VStack(alignment: .leading){
            HStack (alignment: .center) {
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(.white)
                Text(iconTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
            .padding(.leading, 20)
            Divider()
                .background(.white)
                .padding(.top, 10)
        }
    }
}
