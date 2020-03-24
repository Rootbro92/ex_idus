//
//  Router.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/24.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import Moya

enum Idus {
    case productList(page: Int)
}

extension Idus: TargetType {
    
    var baseURL: URL { return URL(string: "https://2jt4kq01ij.execute-api.ap-northeast-2.amazonaws.com/prod")! }
    var path: String {
        switch self {
        case .productList:
            return "/products"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .productList:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .productList:
            return "test data".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .productList(let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
     
}