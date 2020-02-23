//
//  ProductListViewController.swift
//  ex_idus
//
//  Created by 박근형 on 2020/02/22.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productListCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        /*
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "YOURIMAGE")
        imageView.image = image
        navigationItem.titleView = imageView
         */
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        productListCollectionView.reloadData()
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        /*
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.reuseIdentifier, for: indexPath) as? MemoCell else {
            return UITableViewCell()
        }*/
        let url = URL(string: "https://image.idus.com/image/files/cd5607df5608474dacc6fb709d0634d3_520.jpg")
        let data = try? Data(contentsOf: url!)
        cell.productImage.image = UIImage(data: data!)
        cell.titleLabel.text = "555"
        cell.sellerLabel.text = "5555"
        return cell
    }
}
extension ProductListViewController: UICollectionViewDelegate {
    
}

