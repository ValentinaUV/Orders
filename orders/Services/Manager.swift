//
//  Manager.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

import FactoryKit

class Manager {
    
    let apiService: ApiServiceProtocol
    let repository: RepositoryProtocol
    
    init(apiService: ApiServiceProtocol, repository: RepositoryProtocol) {
        self.apiService = apiService
        self.repository = repository
    }
    
    func fetchAndSaveOrders() {
        apiService.fetchOrders { result in
            switch result {
            case .success(let orders):
                print("Fetched orders successfully.")
                self.repository.saveOrders(orders: orders)
            case .failure(let error):
                print("Failed to fetch orders: \(error)")
            }
        }
    }

    func fetchAndSaveCustomers() {
        apiService.fetchCustomers { result in
            switch result {
            case .success(let customers):
                print("Fetched customers successfully.")
                self.repository.saveCustomers(customers: customers)
            case .failure(let error):
                print("Failed to fetch customers: \(error)")
            }
        }
    }
    
    func updateOrderStatus(_ order: Order, to newStatus: String) {
        apiService.updateOrderStatus(orderId: order.id, newStatus: newStatus) { result in
            switch result {
            case .success:
                print("Simulated update for order \(order.id) status to '\(newStatus)' succeeded.")

                self.repository.updateOrderStatus(orderId: order.id, to: newStatus)
        
            case .failure(let error):
                print("Simulated update for order \(order.id) failed: \(error)")
            }
        }
    }
}
