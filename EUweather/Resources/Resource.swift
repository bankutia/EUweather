//
//  Resource.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

struct Resource {
    static let euCapitalsJsonFileName = "euCapitals"
    
    struct Service {
        struct Arg {
            static let cityIds = "id"
            static let unit = "units"
            static let apiKey = "APPID"
        }
        
        struct Values {
            struct Units {
                static let metric = "metric"
            }
        }
        
        struct Url {
            static let currentWeather = "http://api.openweathermap.org/data/2.5/weather"
            static let imageStore = "http://openweathermap.org/img/wn"
        }
    }
    
    struct UserDefault {
        static let observingCitiesKey = "observing_cities"
    }
    
    struct WeatherIcon {
        static let defaultName = "03d.png"
    }
}
