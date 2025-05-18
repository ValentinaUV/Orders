//
//  CustomerCardViewModel.swift
//  orders
//
//  Created by Valentina Ungurean on 18.05.2025.
//

import SwiftUI
import FactoryKit

class CustomerCardViewModel: ObservableObject {
    @Injected(\.manager) private var manager: Manager
    
    @Published var orders: [Order] = []
    
    func getOrders(for customer: Customer) {
        orders = manager.getOrders(for: customer)
    }
    
}
