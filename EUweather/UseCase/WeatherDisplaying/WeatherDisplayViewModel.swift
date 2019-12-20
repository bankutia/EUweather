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
    
    func addCity(by cityCode: OpenWeatherCityCode) {
        observingCityCodes.insert(cityCode, at: 0)
        provider.getCurrentWeather(by: [cityCode]) { [weak self] result in
            guard case .success(let weatherData) = result, let newCityWeather = weatherData.first else { return }
            
            self?.weatherData.value.insert(newCityWeather, at: 0)
        }
    }
    
    func removeCity(by cityCode: OpenWeatherCityCode) {
        weatherData.value.removeAll(where: { $0.city.code == cityCode })
        observingCityCodes.removeAll(where: { $0 == cityCode })
    }
}
