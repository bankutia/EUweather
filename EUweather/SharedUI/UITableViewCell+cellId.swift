//
//  UITableViewCell+cellId.swift
//  EUweather
//
//  Created by ALi on 2019. 12. 20..
//  Copyright © 2019. ALi. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}
