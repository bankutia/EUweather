//
//  ObservableValue.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

protocol ValueObserver {
    var observerId: UUID { get }
}

class ObservableValue<T> {
    typealias ObservingCompletionHandler = ((T) -> Void)

    var value : T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [UUID: ObservingCompletionHandler]()
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(_ observer: ValueObserver, completionHandler: @escaping ObservingCompletionHandler) {
        observers[observer.observerId] = completionHandler
        self.notify()
    }
    
    func removeObserver(_ observer: ValueObserver) {
        observers.removeValue(forKey: observer.observerId)
    }
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    deinit {
        observers.removeAll()
    }
}
