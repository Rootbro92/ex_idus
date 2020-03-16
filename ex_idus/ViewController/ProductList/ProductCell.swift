//
//  ProductCell.swift
//  ex_idus
//
//  Created by 박근형 on 2020/02/23.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
    struct UI {
        static let imageRadius: CGFloat = 14
    }
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    
    func configure(with product: Product){
        //let url = URL(string: product.thumb)
        productImage.load(with: product.thumb)
        productImage.clipsToBounds = true
        productImage.layer.cornerRadius = UI.imageRadius
        titleLabel.text = product.title
        sellerLabel.text = product.seller
        //print(product)
    }
}
