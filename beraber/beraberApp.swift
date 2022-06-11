//
//  beraberApp.swift
//  beraber
//
//  Created by yozdemir on 13.03.2022.
//

import SwiftUI
import Firebase

@main
struct beraberApp: App {
    @UIApplicationDelegateAdaptor(Appdelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    Auth.auth().canHandle(url)
                }
        }
    }
}
// Fireebase init
class Appdelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Thread.sleep(forTimeInterval: 0.5)
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler:
                     @escaping (UIBackgroundFetchResult) -> Void) {}
}
