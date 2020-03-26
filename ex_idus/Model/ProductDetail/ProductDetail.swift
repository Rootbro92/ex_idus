//
//  ProductDetail.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/27.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation

struct ProductDetailData: Codable {
    var statusCode: Int
    var body: [ProductDetail]
}

struct ProductDetail: Codable {
    var discountCost: String?
    var cost: String
    var seller: String
    var description: String
    var discountRate: String?
    var id: Int
    var thumb: String
    var thumbList: String
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case cost, seller, description, id, title
        case discountCost = "discount_cost"
        case discountRate = "discount_rate"
        case thumb = "thumbnail_720"
        case thumbList = "thumbnail_list_320"
    }
}
