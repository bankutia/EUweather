//
//  WeatherDAO.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

struct WeatherDAO: Codable {
    var main: String
    var description: String
    var icon: String
}

struct TemperatureDAO: Codable {
    var temp: Double
}

struct WeatherReportDAO: Codable {
    var id: Int
    var name: String
    var weather: [WeatherDAO]
    var main: TemperatureDAO
}

struct CurrentWeatherDAO: Codable {
    var list: [WeatherReportDAO]
}

extension CurrentWeatherDAO {
    static var empty: CurrentWeatherDAO {
        CurrentWeatherDAO(list: [])
    }
}
