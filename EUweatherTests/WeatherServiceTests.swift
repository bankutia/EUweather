//
//  WeatherServiceTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class WeatherServiceTests: XCTestCase {

    var service: WeatherService?
    override func setUp() {
        service = WeatherServiceFactory.getInstance()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetWeatherFulfills() {
        let expectation = self.expectation(description: "")
        
        service?.getCurrentWeather(by: ["3054643"]) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetWeatherForOneCityWorks() {
        let expectation = self.expectation(description: "")
        
        service?.getCurrentWeather(by: ["3054643"]) { result in
            if case .success(let currentWeatherDAO) = result {
                XCTAssertEqual(1, currentWeatherDAO.list.count)
                XCTAssertNotNil(currentWeatherDAO.list.first(where: { $0.id == 3054643 }))
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testGetWeatherForTwoCitiesWorks() {
        let expectation = self.expectation(description: "")
        
        service?.getCurrentWeather(by: ["3054643", "2643743"]) { result in
            if case .success(let currentWeatherDAO) = result {
                XCTAssertEqual(2, currentWeatherDAO.list.count)
                XCTAssertNotNil(currentWeatherDAO.list.first(where: { $0.id == 3054643 }))
                XCTAssertNotNil(currentWeatherDAO.list.first(where: { $0.id == 2643743 }))
            } else {
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
