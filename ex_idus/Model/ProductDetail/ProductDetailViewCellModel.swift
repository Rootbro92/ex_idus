//
//  DetailViewCellModel.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/29.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import UIKit

enum ModelItemType {
    case thumb
    case productInfo
    case description
}
 
protocol ModelItem {
    var type: ModelItemType { get }
}
 

struct Thumb: ModelItem {
    let type: ModelItemType = .thumb
    var thumb: String
    var thumbList: [String]
}
 
struct ProductInfo: ModelItem {
    let type: ModelItemType = .productInfo
    var cost: String
    var seller: String
    var title: String

}
 
struct Description: ModelItem {
    let type: ModelItemType = .description
    var description: String
}

protocol MultipleCellDataSource {
    var viewModel: MutipleCellViewModel! { get }
}
 

class MutipleCellViewModel: NSObject {
    var items: [ModelItem]!
     
    init(items: [ModelItem]) {
        super.init()
        self.items = items
    }
}

extension MutipleCellViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
         
        switch item.type {
        case .thumb:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductThumbnailCell.reuseIdentifier, for: indexPath) as! ProductThumbnailCell
            cell.item = item
            return cell
            
        case .productInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.reuseIdentifier, for: indexPath) as! ProductInfoCell
            cell.item = item
            return cell
            
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailDescriptionCell.reuseIdentifier, for: indexPath) as! ProductDetailDescriptionCell
            cell.item = item
            return cell
        }
    }
}
