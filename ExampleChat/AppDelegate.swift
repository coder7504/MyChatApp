//
//  AppDelegate.swift
//  ExampleChat
//
//  Created by Mac user on 13/08/21.
//

import UIKit
import AsyncDisplayKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
//        let vc = AudioViewController(nibName: "AudioViewController", bundle: nil)
        let vc = MessageTableNode()
        let vc1 = MessageText()
        let vc2 = MainViewController()
        let nav = UINavigationController(rootViewController: vc2)
        let audio = AudioViewController(nibName: "AudioViewController", bundle: nil)
//        let nav = ASNavigationController(rootViewController: vc)
//        vc.title = "InstaClone"
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }



}

