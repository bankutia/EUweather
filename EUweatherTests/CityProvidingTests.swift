//
//  CityProvidingTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class CityProvidingTests: XCTestCase {

    var provider: CityProviding?
    override func setUp() {
        provider = CityProviderFactory.getInstance()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCityProviderContainsCities() {
        XCTAssertEqual(26, provider?.cities.count)
        XCTAssertEqual("Budapest", provider?.cities["3054643"]?.name)
    }
}
