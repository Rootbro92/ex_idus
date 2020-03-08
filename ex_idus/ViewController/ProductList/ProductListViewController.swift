//
//  ProductListViewController.swift
//  ex_idus
//
//  Created by 박근형 on 2020/02/22.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit
import Alamofire

class ProductListViewController: UIViewController {
//MARK:- Constant
    struct UI {
        static let itemSpacing: CGFloat = 7
        static let lineSpacing: CGFloat = 14
        static let itemWidth: CGFloat = UIScreen.main.bounds.width / 2 * 0.98
        static let itemHeight: CGFloat = itemWidth * 1.5
        static let imageRadius: CGFloat = 14
    }
    
//MARK:- Properties
    var list : [Product] = []


//MARK:- UI Properties
    @IBOutlet weak var productListCollectionView: UICollectionView!
    
//MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveData()
        setupUI()
        setupFlowLayout()
    }
}

//MARK:- Methods
extension ProductListViewController {
    func receiveData(){
        let baseUrl = "https://2jt4kq01ij.execute-api.ap-northeast-2.amazonaws.com"
        let path = "/prod/products"
        
        AF.request(baseUrl + path).response { response in
            switch response.result {
            case .success(let data):
                if let jsonData = data {
                    do {
                        let result = try JSONDecoder().decode(ProductData.self, from: jsonData)
                        result.body.forEach {
                            let productInfo = Product(id: $0.id, thumb: $0.thumb, title: $0.title, seller: $0.seller)
                            self.list.append(productInfo)
                        }
                    } catch {
                        print("Decodable Error")
                    }
                    self.productListCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = UI.itemSpacing
        flowLayout.minimumLineSpacing = UI.lineSpacing
        flowLayout.itemSize = CGSize(width: UI.itemWidth , height: UI.itemHeight)
        self.productListCollectionView.collectionViewLayout = flowLayout
    }
    
    func setupUI() {
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        productListCollectionView.reloadData()
    }
}

//MARK:- CollectionView DataSource
extension ProductListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        let url = URL(string: list[indexPath.row].thumb)
        cell.productImage.load(url: url!)
        cell.productImage.clipsToBounds = true
        cell.productImage.layer.cornerRadius = UI.imageRadius
        cell.titleLabel.text = list[indexPath.row].title
        cell.sellerLabel.text = list[indexPath.row].seller
        return cell
    }
}

//MARK:- CollectionView Delegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}



