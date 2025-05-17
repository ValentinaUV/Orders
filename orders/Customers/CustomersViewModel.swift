//
//  CustomersViewModel.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI
import FactoryKit

class CustomersViewModel: ObservableObject {
    @Injected(\.manager) private var manager: Manager
    @Published var customers: [Customer] = []
    
    func getCustomers() {
        customers = manager.getCustomers()
    }
}
