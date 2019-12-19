//
//  Config.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

struct Config {

    private static let configurationKey = "Configuration"
    private static let openWeatherApiKeyKey = "OpenWeatherAPIkey"

    static var buildConfiguration: String {
        guard let config = Bundle.main.object(forInfoDictionaryKey: configurationKey) as? String else {
            fatalError("Missing \(configurationKey) key from Info.plist")
        }
        
        return config
    }
    
    static var openWeatherApiKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: openWeatherApiKeyKey) as? String else {
            fatalError("Missing \(openWeatherApiKeyKey) key from Info.plist")
        }
        
        return apiKey
    }
}
