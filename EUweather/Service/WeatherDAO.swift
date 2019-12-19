//
//  WeatherDAO.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

struct Weather: Codable {
    var main: String
    var description: String
    var icon: String
}

struct Temperature: Codable {
    var temp: Double
}

struct WeatherReportDAO: Codable {
    var id: Int
    var name: String
    var weather: [Weather]
    var main: Temperature
}

struct CurrentWeatherDAO: Codable {
    var list: [WeatherReportDAO]
}
