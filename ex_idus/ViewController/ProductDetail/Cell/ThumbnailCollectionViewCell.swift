//
//  ThumbnailCollectionViewCell.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/30.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var thumb: UIImageView!
    
    func configure(with thumbUrl: String){
        let url = URL(string: thumbUrl)
        thumb.kf.setImage(with: url)
    }
}
