//
//  OrderViewModel.swift
//  orders
//
//  Created by Valentina Ungurean on 18.05.2025.
//

import SwiftUI
import FactoryKit

class OrderViewModel: ObservableObject {
    @Published var order: Order?
    
    @Injected(\.manager) private var manager: Manager
    
    func getOrder(id: Int) {
        order = manager.getOrder(id: id)
    }
    
    func updateOrderStatus(to status: OrderStatus) {
        if let order {
            manager.updateOrderStatus(order, to: status)
        }
    }
}
