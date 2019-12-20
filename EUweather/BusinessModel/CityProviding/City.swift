//
//  City.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

typealias CountryCode = String

struct City: Codable, Equatable {
    var code: OpenWeatherCityCode
    var name: String
    var countryCode: CountryCode
    
    static let empty = City(code: "", name: "", countryCode: "")
}

typealias OpenWeatherCityCode = String
typealias OpenWeatherCityCodes = Dictionary<OpenWeatherCityCode, City>
