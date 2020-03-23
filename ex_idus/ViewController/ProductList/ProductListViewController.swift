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
        static let FooterViewHeight: CGFloat = 55
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
        flowLayout.footerReferenceSize = CGSize(width: productListCollectionView.bounds.size.width, height: 55)
        self.productListCollectionView.collectionViewLayout = flowLayout
    }
    
    func setupUI() {
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        productListCollectionView.refreshControl = refreshControl
        productListCollectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        productListCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingReusableView.reuseIdentifier)
        
    }
    
    func reload() {
        productListCollectionView.reloadData()
        productListCollectionView.refreshControl?.endRefreshing()
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.reload()
                    self?.isLoading = false
                }
            }
        }
    }
    
    @objc func refresh() {
        print("refresh")
        //승진: refresh 플로우는 외우는것도 좋아
        //1. 가지고 있던 데이터 전체 삭제 (list 배열)
        //2. 다시 데이터 불로오기
        
        
        //NSThread sleep vs dispatch after 두개 찾아봐
        //Thread sleep은 좋은 방법이 아니다.
        //다른것도 다 바꿔
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.list.removeAll(keepingCapacity: true)
            self?.receiveData()
            
            DispatchQueue.main.async { [weak self] in
                self?.reload()
                //난 reload에 refreshcontrol을 end 로직까지 넣었다.
            }
        }
        
        
        //        DispatchQueue.global().async { [weak self] in
        //            self?.list.removeAll()
        //            self?.receiveData()
        //            Thread.sleep(forTimeInterval: 2)
        //
        //            DispatchQueue.main.async { [weak self] in
        //                self?.reload()
        //                self?.productListCollectionView.refreshControl?.endRefreshing()
        //            }
        //        }
    }
}


//MARK:- CollectionView DataSource

extension ProductListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        print("referenceSizeForFooterInSection")
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: UI.FooterViewHeight)
        }
    }
}

//MARK:- CollectionView Delegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplayCell")
        if indexPath.row == list.count - 10 && !self.isLoading {
            loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.reuseIdentifier, for: indexPath) as! LoadingReusableView
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



