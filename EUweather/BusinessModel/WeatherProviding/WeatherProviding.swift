//
//  WeatherProviding.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

enum WeatherProviderError: Error {
    case serviceError(Error)
}

protocol WeatherProviding {
    func getCurrentWeather(by cityCodes: [OpenWeatherCityCode], completion: @escaping (Result<[CityWeather], Error>) -> Void)
}

final class WeatherProviderFactory {
    static var mockedInstance: WeatherProviding?
    class func getInstance() -> WeatherProviding {
        mockedInstance ?? WeatherProvider()
    }
}

private final class WeatherProvider: WeatherProviding, WeatherServiceInjecting, CityProvidingInjected {
    
    private lazy var service: WeatherService = {
        inject()
    }()

    func getCurrentWeather(by cityCodes: [OpenWeatherCityCode], completion: @escaping (Result<[CityWeather], Error>) -> Void) {
        service.getCurrentWeather(by: cityCodes) { result in
            guard case .success(let dao) = result else {
                if case .failure(let error) = result {
                    completion(.failure(WeatherProviderError.serviceError(error)))
                } else {
                    fatalError()
                }
                return
            }
            
            let model = dao.list.map{ $0.toCityWeather(with: self.cityProvider) }
            completion(.success(model))
        }
    }
}

private extension WeatherReportDAO {
    func toCityWeather(with cityProvider: CityProviding) -> CityWeather {
        CityWeather(city: cityProvider.cities[String(id)] ?? City.empty,
                    degree: self.main.temp,
                    iconName: self.weather.first?.icon ?? Resource.WeatherIcon.defaultName
        )
    }
}
