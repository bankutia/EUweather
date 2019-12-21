//
//  MockedCityProvider.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 21..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation
@testable import EUweather

final class MockedCityProvider: CityProviding {
    private let cityCodesDictionary = [
        "1": City(code: "1", name: "Budapest", countryCode: "HU"),
        "2": City(code: "2", name: "Londob", countryCode: "GB")
    ]
    var readCount = 0
    var cities: OpenWeatherCityCodes {
        get {
            readCount += 1
            return cityCodesDictionary
        }
    }
}
