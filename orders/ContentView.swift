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
                if tabSelection == .orders {
                    Text("Orders")
                        .textCase(.uppercase)
                        .font(.title)
                } else {
                    Text("Orders")
                        .font(.title)
                }
            }
            .tag(TabsEnum.orders)
            
            NavigationStack(path: $customersCoodinator.path) {
                CustomersView()
            }
            .tabItem {
                if tabSelection == .customers {
                    Text("Customers")
                        .textCase(.uppercase)
                        .font(.title)
                } else {
                    Text("Customers")
                        .font(.title)
                }
            }
            .tag(TabsEnum.customers)
        }
    }
}

//#Preview {
//    ContentView()
//}
