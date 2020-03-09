//
//  Product.swift
//  ex_idus
//
//  Created by 박근형 on 2020/02/23.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation

struct ProductData: Codable{
    var statusCode: Int
    var body: [Product]
}

struct Product: Codable{
    var id: Int
    var thumb: String
    var title: String
    var seller: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, seller
        case thumb = "thumbnail_520"
    }
    
    init(id: Int, thumb: String, title: String, seller: String) {
        self.id = id
        self.thumb = thumb
        self.title = title
        self.seller = seller
    }
}
