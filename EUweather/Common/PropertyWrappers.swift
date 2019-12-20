//
//  PropertyWrappers.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefault<T>: UserDefaultsInjecting {
    let key: String
    let defaultValue: T
    private var userDefaults: UserDefaults? = nil

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        userDefaults = inject()
    }

    var wrappedValue: T {
        get {
            return userDefaults?.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults?.set(newValue, forKey: key)
        }
    }
}
