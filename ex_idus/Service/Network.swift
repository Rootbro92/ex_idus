//
//  Network.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/10.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case decode
    case notFound
}
enum NetworkResult {
    case success
    case failure
}
struct NetworkResponse {
    let json: Decodable?
    let error: NetworkError?
    let result: NetworkResult
}

class Network {
    
    static let shared = Network()
    
    private init() {
        
    }
    
    func request<T: Decodable>(with url: String, decoder: T.Type, completion: @escaping (NetworkResponse) -> ()) {
        AF.request(url).response { response in
            guard let statusCode = response.response?.statusCode,
                200..<400 ~= statusCode else {
                    completion(NetworkResponse(json: nil, error: .notFound, result: .failure))
                    return
            }
            
            if let jsonData = response.data {
                do {
                    let result = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(NetworkResponse(json: result, error: nil, result: .success))
                } catch {
                    print("Decodable Error", error)
                    completion(NetworkResponse(json: nil, error: .decode, result: .failure))
                }
            }
        }
    }
    
    //    func receiveData() {
    //        let baseUrl = "https://2jt4kq01ij.execute-api.ap-northeast-2.amazonaws.com"
    //        let path = "/prod/products"
    
    //        AF.request(baseUrl + path).response { [weak self] response in
    //            switch response.result {
    //            case .success(let data):
    //                if let jsonData = data {
    //                    do {
    //                        JSONDecoder().de
    //                        let result = try JSONDecoder().decode(ProductData.self, from: jsonData)
    //                        self?.list = result.body
    //                    } catch {
    //                        print("Decodable Error")
    //                    }
    //                    self?.reload()
    //                }
    //            case .failure(let error):
    //                print(error)
    //            }
    //        }
    //    }
    
}
