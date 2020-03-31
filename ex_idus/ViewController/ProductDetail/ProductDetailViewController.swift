//
//  ProductDetailViewController.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/09.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    //MARK: - Property
    var id: Int = 0
    var viewModel: MutipleCellViewModel!
    var data: ProductDetail = ProductDetail()
    
    //MARK: - UI Property
    @IBOutlet weak var productDetailTableView: UITableView!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        receiveData(id: id)
    }
    
    private func setupUI() {
        productDetailTableView.delegate = self
        productDetailTableView.estimatedRowHeight = 50
        productDetailTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func reload() {
        productDetailTableView.reloadData()
    }
    
    private func receiveData(id: Int = 1) {
        Network.shared.request(target: .productDetail(id: id), decoder: ProductDetailData.self) { [weak self] response in
            switch response.result {
            case .success:
                let result = response.json as! ProductDetailData
                self?.viewModel = MutipleCellViewModel(items: [
                    Thumb(thumb: result.body[0].thumb, thumbList: result.body[0].thumbList.components(separatedBy: "#")),
                    ProductInfo(cost: result.body[0].cost , seller: result.body[0].seller, title: result.body[0].title),
                    Description(description: result.body[0].description)
                ])
                self?.productDetailTableView.dataSource = self?.viewModel
                self?.reload()
                
            case .failure:
                guard response.error == nil else {
                    print(response.error!)
                    return
                }
            }
        }
    }
    
    //MARK: - IBAction
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - TableView Delegate
extension ProductDetailViewController: UITableViewDelegate {
    
}


