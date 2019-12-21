//
//  CitySelectingViewModelTests.swift
//  EUweatherTests
//
//  Created by ALi on 2019. 12. 21..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class CitySelectingViewModelTests: XCTestCase, ValueObserver {

    var observerId: UUID = .init()
    
    var viewModel: CitySelectingViewModel?
    var mockedCityProvider: MockedCityProvider?
    override func setUp() {
        mockedCityProvider = MockedCityProvider()
        CityProviderFactory.mockedInstance = mockedCityProvider
        viewModel = CitySelectingViewModel(disabledCityCodes: ["1"])
    }

    override func tearDown() {
        CityProviderFactory.mockedInstance = nil
    }

    func testCitySelectingViewModelWithoutFilterWorks() {
        let expectation = self.expectation(description: "testCitySelectingViewModelWithoutFilterWorks")
        viewModel?.cellViewModels.addObserver(self) {
            XCTAssertEqual(1, self.mockedCityProvider?.readCount)
            XCTAssertEqual(2, $0.count)
            XCTAssertNotNil($0.first(where: { $0.isSelectable }))
            XCTAssertNotNil($0.first(where: { !$0.isSelectable }))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
