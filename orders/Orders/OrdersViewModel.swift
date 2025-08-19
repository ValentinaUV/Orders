//
//  OrdersViewModel.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI
import FactoryKit

@MainActor
class OrdersViewModel: ObservableObject {
    @Injected(\.manager) private var manager: AppManager
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    func getOrders() async {
        // Since the class is @MainActor, these updates are implicitly on the main thread
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let fetchedOrders = try await manager.getOrders()
            self.orders = fetchedOrders
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to load orders: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
