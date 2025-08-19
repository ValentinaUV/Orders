//
//  AppManager.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

import Foundation
import FactoryKit
import RealmSwift
import FirebaseAnalytics

enum DataFetchError: Error, LocalizedError {
    case customerFetchFailed
    case orderFetchFailed
    
    var errorDescription: String? {
        switch self {
        case .customerFetchFailed: return "Failed to fetch and save customers."
        case .orderFetchFailed: return "Failed to fetch and save orders."
        }
    }
}

class AppManager {
    
    @Injected(\.apiService) private var apiService: ApiServiceProtocol
    @Injected(\.repository) private var repository: RepositoryProtocol
    @Injected(\.notificationManager) private var notificationManager: NotificationManager
    
    func getOrders() async throws -> [Order] {
        let orders = repository.getAllOrders()
        
        if orders.isEmpty {
            do {
                try await fetchAndSaveCustomers()
                try await fetchAndSaveOrders()
                
                let updatedOrders = self.repository.getAllOrders()
                return updatedOrders
            } catch {
                print("Failed to load initial data due to: \(error.localizedDescription)")
                throw error
            }
        } else {
            return orders
        }
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
    
    func getOrders(for customer: Customer) -> [Order] {
        print("Getting orders for customer ID \(customer.id) from Realm via Manager...")
        return repository.getOrdersForCustomer(customerId: customer.id)
    }
    
    private func fetchAndSaveOrders() async throws {
        do {
            let orders = try await apiService.fetchOrders()
            print("Fetched orders successfully.")
            repository.saveOrders(orders: orders)
        } catch {
            print("Failed to fetch orders: \(error.localizedDescription)")
            throw error
        }
    }

    private func fetchAndSaveCustomers() async throws {
        do {
            let customers = try await apiService.fetchCustomers()
            print("Fetched customers successfully.")
            repository.saveCustomers(customers: customers)
        } catch {
            print("Failed to fetch customers: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateOrderStatus(_ order: Order, to newStatus: OrderStatus) async throws {
        do {
            try await apiService.updateOrderStatus(orderId: order.id, newStatus: newStatus.rawValue)
            print("Update for order \(order.id) status to '\(newStatus)' succeeded in AppManager.")

            self.repository.updateOrderStatus(orderId: order.id, to: newStatus)
            self.notificationManager.scheduleOrderStatusChangeNotification(orderId: order.id, newStatus: newStatus)
            self.logEvent(screenName: "order_screen", screenClass: "OrderView", params: [
                "action": "status_update",
                "order_id": order.id,
                "new_status": newStatus.rawValue
            ])
        }
        catch {
            print("Update for order \(order.id) failed in AppManager: \(error.localizedDescription)")
            throw error
        }
    }
    
    func logEvent(screenName: String, screenClass: String, params: [String: Any] = [:]) {
        var parameters = params
        parameters[AnalyticsParameterScreenName] = screenName
        parameters[AnalyticsParameterScreenClass] = screenClass
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
        print("Logged screen view: \(screenName)")
    }
}
