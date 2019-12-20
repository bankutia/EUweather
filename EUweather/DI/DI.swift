//
//  DI.swift
//  EUweather
//
//  Created by Attila Bánkuti on 2019. 12. 19..
//  Copyright © 2019. mobilefriends. All rights reserved.
//

import Foundation

protocol AppLaunchingInjected {}
extension AppLaunchingInjected {
    var appLauncher: AppLaunching {
        AppLaunchingFactory.getInstance()
    }
}

protocol CityProvidingInjected {}
extension CityProvidingInjected {
    var cityProvider: CityProviding {
        CityProviderFactory.getInstance()
    }
}

protocol WeatherServiceInjecting {}
extension WeatherServiceInjecting {
    func inject() -> WeatherService {
        WeatherServiceFactory.getInstance()
    }
}

protocol WeatherProviderInjecting {}
extension WeatherProviderInjecting {
    func inject() -> WeatherProviding {
        WeatherProviderFactory.getInstance()
    }
}

protocol UserDefaultsInjecting {}
extension UserDefaultsInjecting {
    func inject() -> UserDefaults {
        UserDefaultsFactory.getInstance()
    }
}
