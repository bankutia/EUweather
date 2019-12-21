//
//  ObservableValueTests.swift
//  EUweather
//
//  Created by Attila Bánkuti on 2019. 12. 20..
//  Copyright © 2019. mobilefriends. All rights reserved.
//

import XCTest
@testable import EUweather

class ObservableValueTests: XCTestCase, ValueObserver {

    let observerId: UUID = .init()
    
    func testSubscribtionWorks() {
        let something = ObservableValue<Int>(5)
        var changedValue = 0
        something.addObserver(self) {
            changedValue = $0
        }
        something.value = 4
        something.removeObserver(self)
        something.value = 3
        
        XCTAssertEqual(something.value, 3)
        XCTAssertEqual(changedValue, 4)
    }
}
