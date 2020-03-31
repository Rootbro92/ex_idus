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
    
    var item: ModelItem? {
        didSet {
            guard let item = item as? Description else { return }
            self.detailDescription.text = item.description
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
