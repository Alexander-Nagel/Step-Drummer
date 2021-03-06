//
//  AppDelegate.swift
//  AVFoundation Test 8 Timer @ half periodLength
//
//  Created by Alexander Nagel on 02.05.21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : K.Color.blue]
        UINavigationBar.appearance().barTintColor = K.Color.orange
        UINavigationBar.appearance().tintColor = K.Color.blue


        
//        let data = Data()
//        data.name = "Alex"
//        data.age = 46
        
//        do {
//            let realm = try Realm()
//            try realm.write {
//                realm.add(data)
//            }
//        } catch {
//            print("Error initialising new realm \(error)")
//        }
//        
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

