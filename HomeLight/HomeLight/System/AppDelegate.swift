//
//  AppDelegate.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import UIKit
import FirebaseCore
import GoogleSignIn
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: PlacesListCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow()
        window?.overrideUserInterfaceStyle = .light
        mainCoordinator = PlacesListCoordinator(window: window!)
        mainCoordinator?.start()
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 32
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(rgb: 0xF6F7FB)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x0346F2)]
        UINavigationBar.appearance().standardAppearance = appearance;
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBar.appearance().standardAppearance
        UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x0346F2)
        UINavigationBar.appearance().tintColor = UIColor(rgb: 0x0346F2)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x0346F2)]
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
