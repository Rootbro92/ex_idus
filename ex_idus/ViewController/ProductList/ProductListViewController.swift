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
    
    //MARK: Constant
    
    struct UI {
        static let itemSpacing: CGFloat = 7
        static let lineSpacing: CGFloat = 14
        static let itemWidth: CGFloat = UIScreen.main.bounds.width / 2 * 0.98
        static let itemHeight: CGFloat = itemWidth * 1.5
    }
    
    //MARK: Properties
    
    var list : [Product] = []
    private var refreshControl = UIRefreshControl()
    var isLoading = false
    var loadingView: LoadingReusableView?
    
    //MARK: UI Properties
    
    @IBOutlet weak var productListCollectionView: UICollectionView!
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveData()
        setupUI()
        setupFlowLayout()
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        productListCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
    }
}

//MARK:- Methods

extension ProductListViewController {
    func receiveData() {
        
        let baseUrl = "https://2jt4kq01ij.execute-api.ap-northeast-2.amazonaws.com"
        let path = "/prod/products"
        Network.shared.request(with: baseUrl + path, decoder: ProductData.self) { [weak self] response in
            
            switch response.result {
            case .success:
                //print(response.json as! ProductData)
                let result = response.json as! ProductData
                self?.list = result.body
                self?.reload()
            case .failure:
                guard response.error == nil else {
                    print(response.error!)
                    switch response.error! {
                    case .decode:
                        print("decode Error")
                    case .notFound:
                        print("통신 에러")
                    }
                    return
                }
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
        productListCollectionView.refreshControl = refreshControl
        productListCollectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    func reload() {
        productListCollectionView.reloadData()
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Fake background loading task for 2 seconds
                sleep(2)
                // Download more data here
                DispatchQueue.main.async {
                    self.reload()
                    self.isLoading = false
                }
            }
        }
    }
    
    @objc func refresh() {
        print("refresh")
        DispatchQueue.global().async { [weak self] in
            self?.list.removeAll()
            self?.receiveData()
            Thread.sleep(forTimeInterval: 2)
            
            DispatchQueue.main.async { [weak self] in
                self?.reload()
                self?.productListCollectionView.refreshControl?.endRefreshing()
            }
        }
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
        cell.configure(with: list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
}

//MARK:- CollectionView Delegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == list.count - 5 && !self.isLoading {
            loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    
    
}



