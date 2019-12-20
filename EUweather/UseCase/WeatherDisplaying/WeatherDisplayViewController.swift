//
//  WeatherDisplayViewController.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

final class WeatherDisplayViewController: UIViewController, ValueObserver {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewEmptyBG: UIView!
    
    let observerId: UUID = .init()
    
    private lazy var viewModel: WeatherDisplayViewModel = {
        WeatherDisplayViewModel()
    }()
    private var weatherData: [CityWeather] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.weatherData.addObserver(self) { [weak self] weatherData in
            guard let self = self else { return }
            
            if weatherData.isEmpty {
                self.tableView.backgroundView = self.viewEmptyBG
            } else {
                self.weatherData = weatherData
                self.tableView.reloadData()
            }
        }
    }
}

extension WeatherDisplayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell")!
    }
    
    
}
