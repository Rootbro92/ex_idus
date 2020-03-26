//
//  ProductDetailViewController.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/09.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        receiveData()
    }
    
    private func receiveData(id: Int = 1) {
        
        Network.shared.request(target: .productDetail(id: id), decoder: ProductDetailData.self) { [weak self] response in
            switch response.result {
            case .success:
                let result = response.json as! ProductDetailData
                print(result)
            case .failure:
                guard response.error == nil else {
                    print(response.error!)
                    return
                }
            }
        }
    }

}
