//
//  CityProviding.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

protocol CityProviding {
    var cities: CityWeatherCodes { get }
}

final class CityProviderFactory {
    static var mockedInstance: CityProviding?
    class func getInstance() -> CityProviding {
        mockedInstance ?? CityProvider.sharedProvider
    }
}

private final class CityProvider: CityProviding {
    var cities: CityWeatherCodes
    
    static let sharedProvider = CityProvider()
    
    init() {
        cities = .init()
        if let path = Bundle.main.path(forResource: Resource.euCapitalsJsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                cities = try JSONDecoder().decode(CityWeatherCodes.self, from: data)
              } catch {
                   fatalError("Invalid embeded euCapitals.json")
              }
        }
    }
}
