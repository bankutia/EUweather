//
//  CitySelectingCellTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 21..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class CitySelectingCellTests: XCTestCase {

    var cell: CitySelectingCell?
    var labelFlag = UILabel()
    var labelName = UILabel()
    override func setUp() {
        cell = CitySelectingCell()
        cell?.labelFlag = labelFlag
        cell?.labelName = labelName
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetEnabledViewModelWorks() {
        cell?.set(viewModel: CitySelectingCell.ViewModel(flag: "X", cityName: "Budapest", cityCode: "1", isSelectable: true))
        XCTAssertEqual("X", labelFlag.text)
        XCTAssertEqual("Budapest", labelName.text)
        XCTAssertEqual(cell?.contentView.alpha, 1.0)
        XCTAssertEqual(cell?.selectionStyle, .default)
    }
    
    func testSetDisabledViewModelWorks() {
        cell?.set(viewModel: CitySelectingCell.ViewModel(flag: "X", cityName: "Budapest", cityCode: "1", isSelectable: false))
        XCTAssertNotEqual(cell?.contentView.alpha, 1.0)
        XCTAssertEqual(cell?.selectionStyle, UITableViewCell.SelectionStyle.none)
    }
}
