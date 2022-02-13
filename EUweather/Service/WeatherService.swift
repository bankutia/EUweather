//
//  WeatherService.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation
import Combine

enum WeatherServiceError: Error {
    case serviceError(String), invalidJson(String)
}

protocol WeatherService {
    func getCurrentWeather(by cityIds: [OpenWeatherCityCode], completion: @escaping (Result<CurrentWeatherDAO, Error>) -> Void)
}

class WeatherServiceFactory {
    static var mockedInstance: WeatherService?
    class func getInstance() -> WeatherService {
        mockedInstance ?? WeatherServiceImpl()
    }
}

private final class WeatherServiceImpl: WeatherService {
    
    var disposeBag: Set<AnyCancellable> = .init()
    
    lazy private var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 1.5
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()

    func getCurrentWeather(by cityIds: [OpenWeatherCityCode], completion: @escaping (Result<CurrentWeatherDAO, Error>) -> Void) {
        guard cityIds.isNotEmpty else {
            completion(.success(CurrentWeatherDAO.empty))
            return
        }
        
        Publishers.MergeMany(
            cityIds.map({ self.getCityWeather(by: $0) })
        ).collect().sink { result in
            if case .failure(let error) = result {
                completion(.failure(error))
            }
        } receiveValue: { weatherReports in
            completion(.success(.init(list: weatherReports)))
        }.store(in: &disposeBag)
    }
    
    private func getCityWeather(by cityId: String) -> AnyPublisher<WeatherReportDAO, Error> {
        session.dataTaskPublisher(for: buildCityWeatherQueryUrl(by: cityId)).tryMap({ (data: Data, response: URLResponse) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == HTTPStatusCode.ok.rawValue else {
                throw WeatherServiceError.serviceError(String((response as? HTTPURLResponse)?.statusCode ?? HTTPStatusCode.internalServerError.rawValue))
            }
            
            if let weatherReportDAO = try? JSONDecoder().decode(WeatherReportDAO.self, from: data) {
                return weatherReportDAO
            } else {
                if let responseString = String(data: data, encoding: .utf8) {
                    throw WeatherServiceError.invalidJson(responseString)
                } else {
                    throw WeatherServiceError.serviceError(String(HTTPStatusCode.internalServerError.rawValue))
                }
            }
        }).mapError({ $0 }).eraseToAnyPublisher()
    }
    
    private func buildCityWeatherQueryUrl(by cityId: String) -> URL {
        guard var urlComponents = URLComponents(string: Resource.Service.Url.currentWeather) else {
            fatalError("Invalid resource for url: requesting current weather!")
        }
        
        urlComponents.queryItems = [
            .init(name: Resource.Service.Arg.cityIds, value: cityId),
            .init(name: Resource.Service.Arg.unit, value: Resource.Service.Values.Units.metric),
            .init(name: Resource.Service.Arg.apiKey, value: Config.openWeatherApiKey)
        ]
        
        return urlComponents.url!
    }
}
