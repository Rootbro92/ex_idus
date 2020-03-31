//
//  ProductInfoCell.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/27.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit

class ProductInfoCell: UITableViewCell {

    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    var item: ModelItem? {
        didSet {
            guard let item = item as? ProductInfo else { return }
            self.seller.text = item.seller
            self.title.text = item.title
            self.cost.text = item.cost
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
