//
//  ProductDetailViewController.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/09.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit
import SnapKit

class ProductDetailViewController: BaseViewController {
    // MARK: Constant
    
    struct UI {
        struct purchaesButton {
            static let leading: CGFloat = 30
            static let trailing: CGFloat = -30
            static let height: CGFloat = 60
            static let bottom: CGFloat = 160
            static let connerRadius: CGFloat = 15
            static let increaseAnimationCenterY: CGFloat = 190
        }
        struct productDetailTableView {
            static let estimatedRowHeight: CGFloat = 50
        }
    }
    
    // MARK: Property
    
    var id: Int = 0
    var detailData: ProductDetail = ProductDetail()
    
    // MARK: UI Property
    
    @IBOutlet weak var productDetailTableView: UITableView!
    @IBOutlet weak var purchaseButton: UIButton!
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveData(id: id)
        productDetailTableView.backgroundColor = AppTheme.color.main
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIButton.animate(withDuration: 1.5,
        delay: 0.2,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 1.0,
        options: [.curveEaseInOut],
        animations: {
            self.purchaseButton.center.y -= UI.purchaesButton.increaseAnimationCenterY }
        )
    }
    
    override func setupUI() {
         productDetailTableView.delegate = self
         productDetailTableView.dataSource = self
        productDetailTableView.estimatedRowHeight = UI.productDetailTableView.estimatedRowHeight
         productDetailTableView.rowHeight = UITableView.automaticDimension
         purchaseButton.layer.cornerRadius = UI.purchaesButton.connerRadius
         self.purchaseButton.snp.makeConstraints {
             $0.trailing.equalToSuperview().offset(UI.purchaesButton.trailing)
             $0.leading.equalToSuperview().offset(UI.purchaesButton.leading)
             $0.height.equalTo(UI.purchaesButton.height)
             $0.bottom.equalToSuperview().offset(UI.purchaesButton.bottom)
         }
     }
    
    // MARK: Methods
    
    private func reload() {
        productDetailTableView.reloadData()
    }
    
    private func receiveData(id: Int = 1) {
        Network.shared.request(target: .productDetail(id: id), decoder: ProductDetailData.self) { [weak self] response in
            switch response.result {
            case .success:
                let result = response.json as! ProductDetailData
                self?.detailData = result.body.first!
                self?.reload()
                
            case .failure:
                guard response.error == nil else {
                    print(response.error!)
                    return
                }
            }
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
