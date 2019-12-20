//
//  CityProviding.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

protocol CityProviding {
    var cities: OpenWeatherCityCodes { get }
}

final class CityProviderFactory {
    static var mockedInstance: CityProviding?
    class func getInstance() -> CityProviding {
        mockedInstance ?? CityProvider.sharedProvider
    }
}

private struct OpenWeatherCityCodesJSON: Codable {
    var name: String
    var countryCode: CountryCode
}

private final class CityProvider: CityProviding {
    var cities: OpenWeatherCityCodes
    
    static let sharedProvider = CityProvider()
    
    init() {
        cities = .init()
        if let path = Bundle.main.path(forResource: Resource.euCapitalsJsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let cities = try JSONDecoder().decode(Dictionary<OpenWeatherCityCode,OpenWeatherCityCodesJSON>.self, from: data)
                self.cities = .init()
                for (key, value) in cities {
                    self.cities[key] = City(code: key, name: value.name, countryCode: value.countryCode)
                }
              } catch {
                   fatalError("Invalid embeded euCapitals.json")
              }
        }
    }
}
