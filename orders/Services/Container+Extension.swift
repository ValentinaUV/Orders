//
//  Container+Extension.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

import FactoryKit

extension Container {
    var ordersCoordinator: Factory<OrdersCoordinator> {
        self { OrdersCoordinator() }
    }
    
    var customersCoordinator: Factory<CustomersCoordinator> {
        self { CustomersCoordinator() }
    }
    
    var repository: Factory<RepositoryProtocol> {
        self { Repository() }
    }
    
    var apiService: Factory<ApiServiceProtocol> {
        self { RestService() }
    }
    
    var manager: Factory<Manager> {
        self { Manager() }
    }
    
    var notificationManager: Factory<NotificationManager> {
        self { NotificationManager.shared }
    }
}
