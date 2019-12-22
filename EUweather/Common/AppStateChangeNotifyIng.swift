//
//  AppStateChangeNotifyIng.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 22..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit
import os.log

enum AppState {
    case unknown
    case willResignActive
    case willEnterForeground
    case willTerminate
    case willFinishLaunching
    case didFinishLaunching
    case didBecomeActive
    case didEnterBackground
}

protocol AppStateChangeNotifying {
    var previousState: AppState { get }
    var state: ObservableValue<AppState> { get }
    func start(with state: AppState)
}

class AppStateChangeNofityerFactory {
    static var mockedInstance: AppStateChangeNotifying?
    class func getInstance() -> AppStateChangeNotifying {
        mockedInstance ?? AppStateChangeNotifier.sharedNotifyer
    }
}

private final class AppStateChangeNotifier: AppStateChangeNotifying {
    private (set) var previousState: AppState = .unknown
    private (set) var state: ObservableValue<AppState> = .init(.unknown)
    
    static let sharedNotifyer = AppStateChangeNotifier()
    
    init() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { _ in self.changeState(to: .willResignActive) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in self.changeState(to: .didBecomeActive) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willTerminateNotification, object: nil, queue: nil) { _ in self.changeState(to: .willTerminate) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didFinishLaunchingNotification, object: nil, queue: nil) { _ in self.changeState(to: .didFinishLaunching) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in self.changeState(to: .didEnterBackground) }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in self.changeState(to: .willEnterForeground) }
    }
    
    @inline(__always) private func changeState(to state: AppState) {
        previousState = self.state.value
        self.state.value = state
        os_log("State changed: %@ -> %@", "\(previousState)", "\(state)")
    }
    
    func start(with state: AppState = .willFinishLaunching) {
        self.state.value = state
    }
}
