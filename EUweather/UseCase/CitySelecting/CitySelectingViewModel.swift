//
//  CitySelectingViewModel.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import Foundation

final class CitySelectingViewModel: CityProvidingInjected {
    
    private (set) var cellViewModels: ObservableValue<[CitySelectingCell.ViewModel]> = .init([])
    
    init(disabledCityCodes: [OpenWeatherCityCode]) {
        let disabledCityCodeMap = disabledCityCodes.reduce(into: [OpenWeatherCityCode: Bool]()) {
            $0[$1] = true
        }
        cellViewModels.value = cityProvider.cities.values
            .map({ $0.toCellViewModel(isSelectable: disabledCityCodeMap[$0.code] == nil) })
            .sorted(by: { $0.cityName < $1.cityName})
    }
}

private extension City {
    func toCellViewModel(isSelectable: Bool) -> CitySelectingCell.ViewModel {
        CitySelectingCell.ViewModel(flag: countryCode.flagUnicodeCharacter(),
                                    cityName: name,
                                    cityCode: code,
                                    isSelectable: isSelectable)
    }
}

private extension String {
    func flagUnicodeCharacter() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(String(s).first ?? "?")
    }
}
