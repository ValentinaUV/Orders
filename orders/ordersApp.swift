//
//  ordersApp.swift
//  orders
//
//  Created by Valentina Ungurean on 15.05.2025.
//

import SwiftUI
import FactoryKit

@main
struct ordersApp: App {
    @State var tabSelection: TabsEnum = .orders
    
    var body: some Scene {
        WindowGroup {
            ContentView(tabSelection: $tabSelection)
                .environmentObject(Container.shared.ordersCoordinator())
                .environmentObject(Container.shared.customersCoordinator())
        }
    }
}
