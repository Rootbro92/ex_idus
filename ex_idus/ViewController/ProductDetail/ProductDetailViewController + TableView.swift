//
//  ProductDetailViewController + TableView.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/31.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import UIKit

enum ModelItemType: Int {
    case thumb
    case productInfo
    case description
    case total
}

extension ProductDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelItemType.total.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemType = ModelItemType.init(rawValue: indexPath.row)

        switch itemType {
        case .thumb:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductThumbnailCell.reuseIdentifier, for: indexPath) as! ProductThumbnailCell
            cell.configure(thumbList: detailData.thumbList)
            return cell

        case .productInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.reuseIdentifier, for: indexPath) as! ProductInfoCell
            cell.configure(seller: detailData.seller, title: detailData.title, cost: detailData.cost,discountCost: detailData.discountCost, discountRate: detailData.discountRate)
            return cell

        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailDescriptionCell.reuseIdentifier, for: indexPath) as! ProductDetailDescriptionCell
            cell.configure(description: detailData.description)
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate
extension ProductDetailViewController: UITableViewDelegate {

}
