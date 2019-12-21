//
//  WeatherDisplayCell.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit
import Kingfisher

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
        if imageWeather != nil {
            imageWeather.image = nil
            if let imageUrl = URL(string: "\(Resource.Service.Url.imageStore)/\(viewModel.weatherImageFileName.imageFileSpec)") {
                imageWeather.kf.setImage(with: imageUrl,
                                         placeholder: UIImage(),
                                         options: [.transition(.fade(1.0))])
            }
        }
    }
}

private extension String {
    var imageFileSpec: String {
        "\(self)@2x.png"
    }
}

private extension Double {
    func toDisplayString() -> String {
        "\(Int(self.rounded()))\u{00b0}"
    }
}
