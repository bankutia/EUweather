//
//  MiscellaneousTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 21..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class MiscellaneousTests: XCTestCase {

    func testCurrentWeatherDAOEmptyValueWorks() {
        XCTAssertTrue(CurrentWeatherDAO.empty.list.isEmpty)
    }
    
    func testUITableViewCellCellIdWorks() {
        XCTAssertEqual(WeatherDisplayCell.cellId, "WeatherDisplayCell")
    }
}
