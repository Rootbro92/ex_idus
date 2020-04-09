//
//  Network.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/10.
//  Copyright © 2020 pgh. All rights reserved.
//

import Foundation
import Moya
//import Alamofire

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
    let error: MoyaError?
    let result: NetworkResult
}

class Network {

    static let shared = Network()

    let provider = MoyaProvider<Idus>()

    private init() {

    }

    func request<T: Decodable>(target: Idus, decoder: T.Type, completion: @escaping (NetworkResponse) -> Void) {

        provider.request(target) { result in
            switch result {
            case .success(let response):
                guard response.statusCode >= 200 && response.statusCode < 400 else {
                    completion(NetworkResponse(json: nil, error: .statusCode(response), result: .failure))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: response.data)
                    completion(NetworkResponse(json: result, error: nil, result: .success))
                } catch {
                    print("Decodable Error", error)
                    completion(NetworkResponse(json: nil, error: nil, result: .failure))
                }
            case .failure(let error):
                completion(NetworkResponse(json: nil, error: .some(error), result: .failure))
            }
        }
    }
}
