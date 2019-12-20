//
//  CitySelectingViewController.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

final class CitySelectingViewController: UIViewController, ValueObserver {
    
    struct Args {
        var disabledCityCodes: [OpenWeatherCityCode] = .init()
        var citySelected: ((OpenWeatherCityCode) -> Void)? = nil
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var args: Args = .init()
    let observerId: UUID = .init()

    private lazy var viewModel: CitySelectingViewModel = {
        CitySelectingViewModel(disabledCityCodes: args.disabledCityCodes)
    }()
    
    private var cellViewModels: [CitySelectingCell.ViewModel] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        viewModel.cellViewModels.addObserver(self) { [weak self] cellViewModels in
            DispatchQueue.main.async {
                self?.cellViewModels = cellViewModels
                self?.tableView.reloadData()
            }
        }
    }
}

extension CitySelectingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitySelectingCell.cellId) as? CitySelectingCell else {
            fatalError("Cell id not set: \(CitySelectingCell.cellId)")
        }
        
        cell.set(viewModel: cellViewModels[indexPath.row])
        
        return cell
    }
}

extension CitySelectingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellViewModel = cellViewModels[indexPath.row]
        if cellViewModel.isSelectable {
            args.citySelected?(cellViewModel.cityCode)
            dismiss(animated: true, completion: nil)
        }
    }
}
