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
    
    func notContains(where predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try !contains(where: predicate)
    }
}

extension Array where Element : Equatable {
    func notContains(_ element: Element) -> Bool {
        return !contains(element)
    }
}
