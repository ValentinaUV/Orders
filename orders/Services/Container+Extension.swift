//
//  Container+Extension.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

import FactoryKit

extension Container {
    var ordersCoordinator: Factory<OrdersCoordinator> {
        Factory(self) { OrdersCoordinator() }
    }
    
    var customersCoordinator: Factory<CustomersCoordinator> {
        Factory(self) { CustomersCoordinator() }
    }
    
    var repository: Factory<RepositoryProtocol> {
        Factory(self) { Repository() }
    }
    
    var apiService: Factory<ApiServiceProtocol> {
        Factory(self) { RestService() }
    }
    
    var manager: Factory<Manager> {
        self { Manager() }
    }
}
