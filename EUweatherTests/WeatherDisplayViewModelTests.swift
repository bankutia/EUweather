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
    var mockedCityProvider: MockedCityProvider?
    private var mockedWeatherProvider: MockedWeatherProvider?
    override func setUp() {
        mockedUserDefaults = UserDefaults(suiteName: "mock")
        mockedUserDefaults?.removePersistentDomain(forName: "mock")
        UserDefaultsFactory.mockedInstance = mockedUserDefaults
        mockedCityProvider = MockedCityProvider()
        CityProviderFactory.mockedInstance = mockedCityProvider
    }
    
    override func tearDown() {
        UserDefaultsFactory.mockedInstance = .none
        WeatherProviderFactory.mockedInstance = .none
        CityProviderFactory.mockedInstance = .none
    }
    
    func testViewModelWithoutStoredCityCodesWorks() {
        let expecation = self.expectation(description: "viewModelObserving")
        mockedWeatherProvider = MockedWeatherProvider(mockedResults: [.success([])])
        WeatherProviderFactory.mockedInstance = mockedWeatherProvider
        viewModel = WeatherDisplayViewModel()
        viewModel?.weatherData.addObserver(self) {
            XCTAssertEqual(0, $0.count)
            XCTAssertEqual([], self.mockedWeatherProvider?.callerCityCodes.first)
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 1.0)
    }
    
    func testViewModelWithStoredCityCodesWorks() {
        let expecation = self.expectation(description: "viewModelObserving")
        mockedWeatherProvider =
            MockedWeatherProvider(mockedResults: [.success([getMockedCityWeather()])])
        WeatherProviderFactory.mockedInstance = mockedWeatherProvider
        mockedUserDefaults?.set(["2"], forKey: Resource.UserDefault.observingCitiesKey)
        viewModel = WeatherDisplayViewModel()
        viewModel?.weatherData.addObserver(self) {
            XCTAssertEqual(1, $0.count)
            XCTAssertEqual(["2"], self.mockedWeatherProvider?.callerCityCodes.first)
            XCTAssertNotNil($0.first(where: { $0.city == City(code: "2", name: "London", countryCode: "GB") && $0.degree == 10.5 && $0.iconName == "icon" }))
            expecation.fulfill()
        }
        
        wait(for: [expecation], timeout: 1.0)
    }
    
    private func getMockedCityWeather() -> CityWeather {
        CityWeather(city: City(code: "2", name: "London", countryCode: "GB"), degree: 10.5, iconName: "icon")
    }
    
    func testViewModelAddWorks() {
        let expecation = self.expectation(description: "viewModelObserving")
        mockedWeatherProvider = MockedWeatherProvider(mockedResults: [.success([]), .success([getMockedCityWeather()])])
        WeatherProviderFactory.mockedInstance = mockedWeatherProvider
        viewModel = WeatherDisplayViewModel()
        var callCount = 0
        viewModel?.weatherData.addObserver(self) {
            guard callCount == 1 else {
                callCount += 1
                return
            }
            XCTAssertEqual(1, $0.count)
            XCTAssertNotNil($0.first(where: { $0.city.code == "2" }))
            XCTAssertEqual(["2"], self.mockedWeatherProvider?.callerCityCodes.last)
            expecation.fulfill()
        }
        
        viewModel?.addCity(by: "2")
        
        wait(for: [expecation], timeout: 1.0)
    }
    
    func testViewModelRemoveWorks() {
        let expecation = self.expectation(description: "viewModelObserving")
        mockedWeatherProvider = MockedWeatherProvider(mockedResults: [.success([getMockedCityWeather()]), .success([])])
        WeatherProviderFactory.mockedInstance = mockedWeatherProvider
        mockedUserDefaults?.set(["2"], forKey: Resource.UserDefault.observingCitiesKey)
        viewModel = WeatherDisplayViewModel()
        var callCount = 0
        viewModel?.weatherData.addObserver(self) {
            guard callCount == 1 else {
                callCount += 1
                return
            }
            XCTAssertEqual(0, $0.count)
            expecation.fulfill()
        }
        
        viewModel?.removeCity(by: "2")
        
        wait(for: [expecation], timeout: 1.0)
    }
}

private final class MockedWeatherProvider: WeatherProviding {
    var callerCityCodes: [[OpenWeatherCityCode]] = .init()
    var mockedResults: [Result<[CityWeather], Error>]
    private var callCount = 0
    
    init(mockedResults: [Result<[CityWeather], Error>]) {
        self.mockedResults = mockedResults
    }
    
    func getCurrentWeather(by cityCodes: [OpenWeatherCityCode], completion: @escaping (Result<[CityWeather], Error>) -> Void) {
        callerCityCodes.append(cityCodes)
        completion(mockedResults[callCount])
        callCount += 1
    }
}
