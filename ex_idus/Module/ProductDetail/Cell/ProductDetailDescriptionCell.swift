//
//  ProductDetailDescriptionCell.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/29.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit

class ProductDetailDescriptionCell: UITableViewCell {

    @IBOutlet weak var detailDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(description: String) {
        self.detailDescription.text = description
    }

}
