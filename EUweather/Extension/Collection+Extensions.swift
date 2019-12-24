//
//  Collection+Extensions.swift
//  ExchangeRates
//
//  Created by Attila Bánkuti on 2019. 10. 25..
//  Copyright © 2019. mobilefriends. All rights reserved.
//

import Foundation

extension RandomAccessCollection {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension Array where Element: Equatable {
    func notContains(_ element: Element) -> Bool {
        !contains(element)
    }
}

extension Array {
    func element(at index: Int) -> Element? {
        guard index < count, index >= 0 else { return nil }
        
        return self[index]
    }
}
