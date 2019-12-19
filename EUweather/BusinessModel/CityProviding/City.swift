//
//  City.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation


struct City: Codable {
    var name: String
    var countryCode: String
}

typealias CityWeatherCode = String
typealias CityWeatherCodes = Dictionary<CityWeatherCode, City>
