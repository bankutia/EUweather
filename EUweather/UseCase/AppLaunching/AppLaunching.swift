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
    
    static let configurationKey = "Configuration"
    static let testConfigurationName = "UnitTest"
    
    class func getInstance() -> AppLaunching {
        guard let config = Bundle.main.object(forInfoDictionaryKey: configurationKey) as? String, config == testConfigurationName else {
            return AppLauncher()
        }
        
        return TestLauncher()
    }
}

private class AppLauncher: AppLaunching {
    func didFinishLunchingWithOptions(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?, _ application: UIApplication, appDelegate: AppDelegate) {
        
        // do any customization...
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
