//
//  WeatherDisplayCell.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

final class WeatherDisplayCell: UITableViewCell {
    
    struct ViewModel {
        var cityCode: OpenWeatherCityCode
        var cityName: String
        var degree: Double
        var weatherImageFileName: String
    }
    
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelDegree: UILabel!
    
    func set(viewModel: ViewModel) {
        labelCity.text = viewModel.cityName
        labelDegree.text = viewModel.degree.toDisplayString()
        
    }
}

private extension Double {
    func toDisplayString() -> String {
//        if self == Double(round(self)) {
            return String(self)
//        }
    }
}
