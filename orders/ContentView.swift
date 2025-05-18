//
//  ContentView.swift
//  orders
//
//  Created by Valentina Ungurean on 15.05.2025.
//

import SwiftUI
import FactoryKit

enum TabsEnum: String, CaseIterable {
    case orders
    case customers
}

struct ContentView: View {
    
    @EnvironmentObject var ordersCoordinator: OrdersCoordinator
    @EnvironmentObject var customersCoodinator: CustomersCoordinator
    
    @Binding var tabSelection: TabsEnum
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack(path: $ordersCoordinator.path) {
                OrdersView()
            }
            .tabItem {
                Label("Orders", systemImage: "list.number")
                    .textCase(tabSelection == .orders ? .uppercase : .none)
            }
            .tag(TabsEnum.orders)
            
            NavigationStack(path: $customersCoodinator.path) {
                CustomersView()
            }
            .tabItem {
                Label("Customers", systemImage: "person.fill")
                    .textCase(tabSelection == .customers ? .uppercase : .none)
            }
            .tag(TabsEnum.customers)
        }
    }
}

