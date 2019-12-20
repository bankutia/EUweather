//
//  UserDefaultsProviding.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

final class UserDefaultsFactory {
    static var mockedInstance: UserDefaults?
    class func getInstance() -> UserDefaults {
        mockedInstance ?? UserDefaults.standard
    }
}
