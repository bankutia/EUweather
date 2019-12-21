//
//  AppStartingApp.swift
//  EUweather
//
//  Created by Attila Bánkuti on 2019. 12. 19..
//  Copyright © 2019. mobilefriends. All rights reserved.
//

import Foundation
import UIKit

protocol AppLaunching {
    func didFinishLunchingWithOptions(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?, _ application: UIApplication, appDelegate: AppDelegate)
}

class AppLaunchingFactory {
    
    static let testConfigurationName = "UnitTest"
    
    class func getInstance() -> AppLaunching {
        guard Config.buildConfiguration == testConfigurationName else {
            return AppLauncher()
        }
        
        return TestLauncher()
    }
}

private class AppLauncher: AppLaunching {
    func didFinishLunchingWithOptions(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?, _ application: UIApplication, appDelegate: AppDelegate) {
        
        if Config.buildConfiguration == "UITest" {
            let mockedUserDefaults = UserDefaults(suiteName: "uiTest")
            mockedUserDefaults?.removePersistentDomain(forName: "uiTest")
            UserDefaultsFactory.mockedInstance = mockedUserDefaults
        }
    }
}

private class TestLauncher: AppLaunching {
    
    let testRunnerStoryboard = "Test"
    
    func didFinishLunchingWithOptions(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?, _ application: UIApplication, appDelegate: AppDelegate) {
        
        _ = changeStoryboradByName(testRunnerStoryboard, appDelegate: appDelegate)
    }
    
    private func changeStoryboradByName(_ storyboardName: String, appDelegate: AppDelegate) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()!
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate.window!.rootViewController = viewController

        return viewController
    }

}
