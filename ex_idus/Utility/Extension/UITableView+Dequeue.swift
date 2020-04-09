//
//  Cell+TableViewCellType.swift
//  ex_idus
//
//  Created by 박근형 on 2020/04/10.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func dequeue<Cell>(
        _ reusableCell: Cell.Type,
        for indexPath: IndexPath
    ) -> Cell where Cell: UITableViewCell {
        return dequeueReusableCell(withIdentifier: reusableCell.reuseIdentifier, for: indexPath) as! Cell
    }
}
