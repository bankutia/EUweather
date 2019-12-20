//
//  WeatherDisplayViewModelTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class WeatherDisplayViewModelTests: XCTestCase, ValueObserver {
    
    var observerId: UUID = .init()
    
    var viewModel: WeatherDisplayViewModel?
    var mockedUserDefaults: UserDefaults?
    private var mockedWeatherProvider: MockedWeatherProvider?
    override func setUp() {
        mockedUserDefaults = UserDefaults(suiteName: "mock")
        mockedUserDefaults?.removePersistentDomain(forName: "mock")
        UserDefaultsFactory.mockedInstance = mockedUserDefaults
    }
    
    override func tearDown() {
        UserDefaultsFactory.mockedInstance = .none
        WeatherProviderFactory.mockedInstance = .none
    }
    
    func testViewModelWithoutStoredCityCodesWorks() {
        let expecation = self.expectation(description: "viewModelObserving")
        mockedWeatherProvider = MockedWeatherProvider(mockedResult: .success([]))
        WeatherProviderFactory.mockedInstance = mockedWeatherProvider
        viewModel = WeatherDisplayViewModel()
        viewModel?.weatherData.addObserver(self) {
            XCTAssertEqual(0, $0.count)
            XCTAssertEqual([], self.mockedWeatherProvider?.callerCityCodes)
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 1.0)
    }
    
    func testViewModelWithStoredCityCodesWorks() {
        let expecation = self.expectation(description: "viewModelObserving")
        mockedWeatherProvider =
            MockedWeatherProvider(mockedResult: .success([CityWeather(city: City(name: "London", countryCode: "EN"), degree: 10.5, iconName: "icon")]))
        WeatherProviderFactory.mockedInstance = mockedWeatherProvider
        mockedUserDefaults?.set(["123456"], forKey: Resource.UserDefault.observingCitiesKey)
        viewModel = WeatherDisplayViewModel()
        viewModel?.weatherData.addObserver(self) {
            XCTAssertEqual(1, $0.count)
            XCTAssertEqual(["123456"], self.mockedWeatherProvider?.callerCityCodes)
            XCTAssertNotNil($0.first(where: { $0.city == City(name: "London", countryCode: "EN") && $0.degree == 10.5 && $0.iconName == "icon" }))
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 1.0)
    }
}

private final class MockedWeatherProvider: WeatherProviding {
    var callerCityCodes: [OpenWeatherCityCode] = .init()
    var mockedResult: Result<[CityWeather], Error>
    
    init(mockedResult: Result<[CityWeather], Error>) {
        self.mockedResult = mockedResult
    }
    
    func getCurrentWeather(by cityCodes: [OpenWeatherCityCode], completion: @escaping (Result<[CityWeather], Error>) -> Void) {
        callerCityCodes = cityCodes
        completion(mockedResult)
    }
}
