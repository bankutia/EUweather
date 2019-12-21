//
//  CitySelectingCell.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

final class CitySelectingCell: UITableViewCell {
    
    @IBOutlet weak var labelFlag: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    struct ViewModel {
        var flag: String
        var cityName: String
        var cityCode: String
        var isSelectable: Bool
    }
    
    private let unselectableRowAlpha: CGFloat = 0.35
    private let selectableRowAlpha: CGFloat = 1.0
    func set(viewModel: ViewModel) {
        labelFlag.text = viewModel.flag
        labelName.text = viewModel.cityName
        
        if viewModel.isSelectable {
            contentView.alpha = selectableRowAlpha
            selectionStyle = .default
        } else {
            contentView.alpha = unselectableRowAlpha
            selectionStyle = .none
        }
    }
}
