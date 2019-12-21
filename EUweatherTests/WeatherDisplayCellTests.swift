//
//  WeatherDisplayCellTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 21..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class WeatherDisplayCellTests: XCTestCase {

    var cell: WeatherDisplayCell?
    var cityLabel = UILabel()
    var degreeLabel = UILabel()
    override func setUp() {
        cell = WeatherDisplayCell()
        cell?.labelCity = cityLabel
        cell?.labelDegree = degreeLabel
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelSettingWorks() {
        cell?.set(viewModel: WeatherDisplayCell.ViewModel(cityCode: "1", cityName: "Budapest", degree: 10.5, weatherImageFileName: ""))
        XCTAssertEqual("Budapest", cell?.labelCity.text)
        XCTAssertEqual("11\u{00b0}", cell?.labelDegree.text)
    }
}
