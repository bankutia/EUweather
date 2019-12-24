//
//  WeatherDisplayViewController.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 19..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

final class WeatherDisplayViewController: UIViewController, ValueObserver, AppStateChangeNotifierInjected {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewEmptyBG: UIView!
    @IBOutlet weak var labelEmptyBG: UILabel!
    
    let observerId: UUID = .init()
    
    private lazy var viewModel: WeatherDisplayViewModel = {
        WeatherDisplayViewModel()
    }()
    private var cellViewModels: [WeatherDisplayCell.ViewModel] = .init()
    private var isManualUpdate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("weatherDisplay_title", comment: "")
        labelEmptyBG.text = NSLocalizedString("weatherDisplay_emptyBackground_title", comment: "")
        
        tableView.estimatedRowHeight = 95
        tableView.rowHeight = UITableView.automaticDimension
        
        viewModel.weatherData.addObserver(self) { [weak self] weatherData in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if weatherData.isEmpty {
                    self.tableView.backgroundView = self.viewEmptyBG
                } else {
                    self.tableView.backgroundView = nil
                }
                self.reloadData(with: weatherData.map{ $0.toViewModel() })
            }
        }
        
        appStateChangeNotifier.state.addObserver(self) { [weak self] appState in
            guard appState == .didBecomeActive, self?.appStateChangeNotifier.previousState != .didFinishLaunching else { return }
            
            self?.viewModel.reload()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigator = segue.destination as? UINavigationController,
            let citySelector = navigator.viewControllers.first as? CitySelectingViewController else { return }
        
        citySelector.args.disabledCityCodes = cellViewModels.map{ $0.cityCode }
        citySelector.args.citySelectedAction = { cityCode in
            self.viewModel.addCity(by: cityCode)
        }
    }
    
    private func reloadData(with viewModels: [WeatherDisplayCell.ViewModel]) {
        guard !isManualUpdate else {
            isManualUpdate = false
            return
        }

        if viewModels.isEmpty {
            cellViewModels = .init()
            tableView.reloadData()
            return
        }
        
        var cellViewModelIndex = cellViewModels.count - 1
        viewModels.reversed().forEach {
            if let cellViewModel = cellViewModels.element(at: cellViewModelIndex), cellViewModel.cityCode == $0.cityCode {
                if let cell = tableView.cellForRow(at: IndexPath(row: cellViewModelIndex, section: 0)) as? WeatherDisplayCell {
                    cell.set(viewModel: $0)
                }
                cellViewModelIndex -= 1
            } else {
                tableView.beginUpdates()
                cellViewModels.insert($0, at: 0)
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    private func setManualUpdate() {
        isManualUpdate = true
    }
}

extension WeatherDisplayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDisplayCell.cellId) as? WeatherDisplayCell else {
            fatalError("Cell id not set: \(WeatherDisplayCell.cellId)")
        }
        
        cell.set(viewModel: cellViewModels[indexPath.row])
        return cell
    }
}

extension WeatherDisplayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            setManualUpdate()
            let cellViewModel = cellViewModels[indexPath.row]
            viewModel.removeCity(by: cellViewModel.cityCode)
            cellViewModels.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

private extension CityWeather {
    func toViewModel() -> WeatherDisplayCell.ViewModel {
        WeatherDisplayCell.ViewModel(cityCode: city.code,
                                     cityName: city.name,
                                     degree: degree,
                                     weatherImageFileName: iconName
        )
    }
}
