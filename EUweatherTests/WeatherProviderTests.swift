//
//  WeatherProviderTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class WeatherProviderTests: XCTestCase {

    var provider: WeatherProviding?
    private var mockedService: MockedWeatherService?
    override func setUp() {
    }

    override func tearDown() {
        WeatherServiceFactory.mockedInstance = .none
    }

    func testGetCurrentWeatherWorks() {
        mockedService = MockedWeatherService(mockedResult: .success(getMockCurrentWeatherDAO()))
        WeatherServiceFactory.mockedInstance = mockedService
        provider = WeatherProviderFactory.getInstance()
        
        let expectation = self.expectation(description: "WeatherProvidingTest")
        provider?.getCurrentWeather(by: ["123456"]) { result in
            XCTAssertEqual(self.mockedService?.callerCityIds, ["123456"])
            if case .success(let weatherData) = result {
                XCTAssertNotNil(weatherData.first(where: { $0.city.countryCode == "GB" && $0.city.name == "London" && $0.degree == 10.5 && $0.iconName == "01d.png" }))
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetCurrentWeatherWithServiceErrorWorks() {
        mockedService = MockedWeatherService(mockedResult: .failure(WeatherServiceError.serviceError("error")))
        WeatherServiceFactory.mockedInstance = mockedService
        provider = WeatherProviderFactory.getInstance()

        let expectation = self.expectation(description: "WeatherProvidingTest")
        provider?.getCurrentWeather(by: ["123456"]) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error as? WeatherProviderError)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func getMockCurrentWeatherDAO() -> CurrentWeatherDAO {
        CurrentWeatherDAO(list: [
            WeatherReportDAO(id: 2643743,
                             name: "London",
                             weather: [WeatherDAO(main: "main", description: "desc", icon: "01d.png")],
                             main: TemperatureDAO(temp: 10.5)
            )
        ])
    }
}

private final class MockedWeatherService: WeatherService {
    var callerCityIds: [OpenWeatherCityCode] = .init()
    var mockedResult: Result<CurrentWeatherDAO, Error>
    
    init(mockedResult: Result<CurrentWeatherDAO, Error>) {
        self.mockedResult = mockedResult
    }
    
    func getCurrentWeather(by cityIds: [OpenWeatherCityCode], completion: @escaping (Result<CurrentWeatherDAO, Error>) -> Void) {
        callerCityIds = cityIds
        sleep(1)
        completion(mockedResult)
    }
}
