//
//  AppDelegate.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppLaunchingInjected, AppStateChangeNotifierInjected {

    var window: UIWindow?
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        appStateChangeNotifier.start(with: .willFinishLaunching)
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appLauncher.didFinishLunchingWithOptions(launchOptions, application, appDelegate: self)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
}

