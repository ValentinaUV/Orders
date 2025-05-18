//
//  RestService.swift
//  orders
//
//  Created by Valentina Ungurean on 15.05.2025.
//

import Foundation
import Alamofire

protocol ApiServiceProtocol {
    func fetchOrders(completion: @escaping (Result<[Order], Error>) -> Void)
    func fetchCustomers(completion: @escaping (Result<[Customer], Error>) -> Void)
    func updateOrderStatus(orderId: Int, newStatus: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class RestService: ApiServiceProtocol {
    private let baseURL = AppConfig.apiURL

    func fetchOrders(completion: @escaping (Result<[Order], Error>) -> Void) {
        let urlString = "\(baseURL)/orders"

        AF.request(urlString, method: .get).responseDecodable(of: [Order].self) { response in
            switch response.result {
            case .success(let ordersArray):
                completion(.success(ordersArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchCustomers(completion: @escaping (Result<[Customer], Error>) -> Void) {
        let urlString = "\(baseURL)/customers"

        AF.request(urlString, method: .get).responseDecodable(of: [Customer].self) { response in
            switch response.result {
            case .success(let customersArray):
                completion(.success(customersArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateOrderStatus(orderId: Int, newStatus: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(baseURL)/orders/\(orderId)"
        let parameters: [String: Any] = ["status": newStatus]
        let headers: HTTPHeaders = [
            "content-type": "application/json"
        ]

        AF.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                print("Simulated update response received. Status code: \(response.response?.statusCode)")
                completion(.success(()))
            case .failure(let error):
                print("Failed to update order status: \(error)")
                completion(.failure(error))
            }
        }
    }
}
