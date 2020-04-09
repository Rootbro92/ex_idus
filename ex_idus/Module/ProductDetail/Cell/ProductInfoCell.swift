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
    
    @IBOutlet weak var discountCostLabel: UILabel!
    @IBOutlet weak var discountRateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(seller: String, title: String, cost: String, discountCost: String?, discountRate: String?) {
        self.seller.text = seller
        self.title.text = title
        self.cost.text = cost
        guard let discountCostText = discountCost, let discountRateText = discountRate else {
            self.discountRateLabel.isHidden = true
            self.discountCostLabel.isHidden = true
            return
        }
        self.cost.attributedText = cost.Strikethrough()
        self.discountCostLabel.text = discountCostText
        self.discountRateLabel.text = discountRateText
    }
}
