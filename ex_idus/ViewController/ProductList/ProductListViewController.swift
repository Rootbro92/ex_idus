//
//  ProductListViewController.swift
//  ex_idus
//
//  Created by 박근형 on 2020/02/22.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit
import Alamofire
import CoreGraphics

class ProductListViewController: UIViewController {

    // MARK: Constant

    struct UI {
        static let itemSpacing: CGFloat = 7
        static let lineSpacing: CGFloat = 14
        static let itemWidth: CGFloat = UIScreen.main.bounds.width / 2 * 0.98
        static let itemHeight: CGFloat = itemWidth * 1.5
        static let FooterViewHeight: CGFloat = 55
    }

    // MARK: Properties

    private var list: [Product] = []
    private var pageNum = 1

    // MARK: UI Properties

    @IBOutlet weak var productListCollectionView: UICollectionView!
    private var refreshControl = UIRefreshControl()
    private var loadingView: LoadingReusableView?
    private var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoading(true)
        receiveData()
        setupUI()
    }
}

// MARK: - Methods

extension ProductListViewController {
    private func receiveData(page: Int = 1) {

        Network.shared.request(target: .productList(page: page), decoder: ProductData.self) { [weak self] response in
            switch response.result {
            case .success:
                //print(response.json as! ProductData)
                let result = response.json as! ProductData
                self?.list.append(contentsOf: result.body)
                self?.reload()
                self?.showLoading(false)
            case .failure:
                self?.showLoading(false)
                guard response.error == nil else {
                    print(response.error!)
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
        flowLayout.itemSize = CGSize(width: UI.itemWidth, height: UI.itemHeight)
        self.productListCollectionView.collectionViewLayout = flowLayout
    }

    private func setupUI() {
        navigationItem.titleView = logoImageView
        setupFlowLayout()
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        productListCollectionView.refreshControl = refreshControl
        productListCollectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        productListCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingReusableView.reuseIdentifier)
        
    }

    private func reload() {
        productListCollectionView.reloadData()
        productListCollectionView.refreshControl?.endRefreshing()
    }

    private func showLoading(_ isLoad: Bool) {
        if isLoad {
            productListCollectionView.refreshControl?.beginRefreshing()
            loadingView?.activityIndicator.startAnimating()
        } else {
            productListCollectionView.refreshControl?.endRefreshing()
            loadingView?.activityIndicator.stopAnimating()
        }
    }

    private func loadMoreData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.pageNum += 1
            self.receiveData(page: self.pageNum)
            self.reload()
        }
    }

    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.list.removeAll(keepingCapacity: true) //메모리 주소 킵
            self?.pageNum = 1
            self?.receiveData()
            self?.reload()
        }
    }
}

// MARK: - CollectionView DataSource

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
}

// MARK: - CollectionView Delegate

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dvc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else {
            return
        }
        dvc.modalPresentationStyle = .fullScreen
        dvc.id = list[indexPath.item].id
        present(dvc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == list.count - 2 {
            loadMoreData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.reuseIdentifier, for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            loadingView?.activityIndicator.startAnimating()
            return aFooterView
        }
        return UICollectionReusableView()
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        if let isLoading = self.loadingView?.activityIndicator.isAnimating, isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: UI.FooterViewHeight)
        }
    }
}
