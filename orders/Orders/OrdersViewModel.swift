//
//  OrdersViewModel.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI
import FactoryKit

class OrdersViewModel: ObservableObject {
    @Injected(\.manager) private var manager: Manager
    @Published var orders: [Order] = []
    
    func getOrders() {
        manager.getOrders { orders in
            self.orders = orders
        }
    }
}
