//
//  DI.swift
//  EUweather
//
//  Created by Attila Bánkuti on 2019. 12. 19..
//  Copyright © 2019. mobilefriends. All rights reserved.
//

import Foundation

protocol AppLaunchingInjected {}
extension AppLaunchingInjected {
    var appLauncher: AppLaunching {
        AppLaunchingFactory.getInstance()
    }
}
