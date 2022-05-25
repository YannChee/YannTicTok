//
//  AppDelegate.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
    
        
//        AVPlayerManager.setAudioMode()
//        NetworkManager.startMonitoring()
//        WebSocketManger.shared().connect()
//        requestPermission()
//
//        VisitorRequest.saveOrFindVisitor(success: { data in
//            let response = data as! VisitorResponse
//            let visitor = response.data
//            Visitor.write(visitor:visitor!)
//        }, failure: { error in
//            print("注册访客用户失败")
//        })

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

