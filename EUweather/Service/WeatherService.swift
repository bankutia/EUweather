//
//  WeatherService.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

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
        
        let url = URL(string: Resource.Service.Url.currentWeather + getQueryParams(by: cityIds))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            guard let statusCode = httpResponse?.statusCode, statusCode == HTTPStatusCode.ok.rawValue, let data = data else {
                completion(.failure(WeatherServiceError.serviceError(String(httpResponse?.statusCode
                    ?? HTTPStatusCode.internalServerError.rawValue))))
                return
            }
            
            if let currentWeatherDAO = try? JSONDecoder().decode(CurrentWeatherDAO.self, from: data) {
                completion(.success(currentWeatherDAO))
            } else {
                if let responseString = String(data: data, encoding: .utf8) {
                    completion(.failure(WeatherServiceError.invalidJson(responseString)))
                } else {
                    completion(.failure(WeatherServiceError.serviceError(String(HTTPStatusCode.internalServerError.rawValue))))
                }
            }
        }
        
        task.resume()
    }
    
    private func getQueryParams(by cityIds: [OpenWeatherCityCode]) -> String {
        "?\(Resource.Service.Arg.cityIds)=\(cityIds.joined(separator: ","))"
        + "&\(Resource.Service.Arg.unit)=\(Resource.Service.Values.Units.metric)"
        + "&\(Resource.Service.Arg.apiKey)=\(Config.openWeatherApiKey)"
    }
}
