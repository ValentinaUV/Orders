//
//  RestService.swift
//  orders
//
//  Created by Valentina Ungurean on 15.05.2025.
//

import Foundation
import Alamofire

protocol ApiServiceProtocol {
    func fetchOrders() async throws -> [Order]
    func fetchCustomers() async throws -> [Customer]
    func updateOrderStatus(orderId: Int, newStatus: String) async throws
}

class RestService: ApiServiceProtocol {
    private let baseURL = AppConfig.apiURL

    func fetchOrders() async throws -> [Order] {
        let urlString = "\(baseURL)/orders"

        let ordersArray = try await AF.request(urlString, method: .get)
            .validate()
            .serializingDecodable([Order].self)
            .value
        return ordersArray
    }

    func fetchCustomers() async throws -> [Customer] {
        let urlString = "\(baseURL)/customers"

        let customersArray = try await AF.request(urlString, method: .get)
            .validate()
            .serializingDecodable([Customer].self)
            .value
        
        return customersArray
    }

    func updateOrderStatus(orderId: Int, newStatus: String) async throws {
        let urlString = "\(baseURL)/orders/\(orderId)"
        let parameters: [String: Any] = ["status": newStatus]
        let headers: HTTPHeaders = [
            "content-type": "application/json"
        ]
        
        let response = await AF.request(urlString,
                                        method: .put,
                                        parameters: parameters,
                                        encoding: JSONEncoding.default,
                                        headers: headers)
                                .validate()
                                .serializingString()
                                .response
        
        switch response.result {
            case .success:
                print("Simulated update response received. Status code: \(response.response?.statusCode ?? -1)")
            case .failure(let error):
                print("Failed to update order status in RestService: \(error.localizedDescription)")
                throw error
        }
    }
}
