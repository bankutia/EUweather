//
//  EUweatherUITests.swift
//  EUweatherUITests
//
//  Created by ALi on 2019. 12. 21..
//  Copyright © 2019. ALi. All rights reserved.
//

import XCTest
@testable import EUweather

class EUweatherUITests: XCTestCase {

    override func setUp() {

        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddCityWorks() {
        
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["Current weather"].buttons["Add"].tap()
        let tablesQuery = app.tables
        let amsterdamStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Amsterdam"]/*[[".cells.staticTexts[\"Amsterdam\"]",".staticTexts[\"Amsterdam\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        amsterdamStaticText.tap()
    }
    
    func testRemoveCityWorks() {
        
        let app = XCUIApplication()
        app.launch()
        
        let addButton = app.navigationBars["Current weather"].buttons["Add"]
        addButton.tap()
        
        let tablesQuery = app.tables
        let amsterdamStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Amsterdam"]/*[[".cells.staticTexts[\"Amsterdam\"]",".staticTexts[\"Amsterdam\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        amsterdamStaticText.tap()
        amsterdamStaticText.tap()
        addButton.tap()
        
        let athensStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Athens"]/*[[".cells.staticTexts[\"Athens\"]",".staticTexts[\"Athens\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        athensStaticText.tap()
        athensStaticText.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        amsterdamStaticText.tap()
    }
}
