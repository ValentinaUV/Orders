//
//  Manager.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

import Foundation
import FactoryKit
import RealmSwift

class Manager {
    
    @Injected(\.apiService) private var apiService: ApiServiceProtocol
    @Injected(\.repository) private var repository: RepositoryProtocol
    
    func getOrders(completion: @escaping ([Order]) -> Void) {
        let orders = repository.getAllOrders()
        if orders.isEmpty {
            fetchAndSaveCustomers()
            fetchAndSaveOrders {
                let updatedOrders = self.repository.getAllOrders()
                completion(updatedOrders)
            }
        }
        completion(orders)
    }
    
    func getOrder(id: Int) -> Order? {
        print("Getting order with ID \(id) from Realm via Manager...")
        return repository.getOrder(id: id)
    }
    
    func getCustomers() -> [Customer] {
        return repository.getAllCustomers()
    }
    
    func getCustomer(id: Int) -> Customer? {
        print("Getting customer with ID \(id) from Realm via Manager...")
        return repository.getCustomer(id: id)
    }
    
    private func fetchAndSaveOrders(closure: @escaping () -> Void) {
        apiService.fetchOrders { result in
            switch result {
            case .success(let orders):
                print("Fetched orders successfully.")
                self.repository.saveOrders(orders: orders)
                closure()
            case .failure(let error):
                print("Failed to fetch orders: \(error)")
            }
        }
    }

    private func fetchAndSaveCustomers() {
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
