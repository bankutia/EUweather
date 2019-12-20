//
//  WeatherDisplayViewModel.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

final class WeatherDisplayViewModel: WeatherProviderInjecting {
    
    private (set) var weatherData: ObservableValue<[CityWeather]> = .init([])
    
    @UserDefault(Resource.UserDefault.observingCitiesKey, defaultValue: [])
    private var observingCityCodes: [OpenWeatherCityCode]
    
    private lazy var provider: WeatherProviding = {
        inject()
    }()
    
    init() {
        provider.getCurrentWeather(by: observingCityCodes) { [weak self] result in
            guard case .success(let weatherData) = result else { return }
            
            self?.weatherData.value = weatherData
        }
    }
}
