//
//  OrdersCoordinator.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI

enum OrdersViews: Hashable, Equatable {
    case ordersView
    case orderView(id: Int)
}

class OrdersCoordinator: ObservableObject{
    @Published var path = NavigationPath()

    func clear() {
        path = .init()
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func gotoOrdersView() {
        clear()
    }
    
    func goToOrderView(id: Int) {
        path.append(OrdersViews.orderView(id: id))
    }
}

enum OrdersViewFactory {
    
    @ViewBuilder
    static func viewForDestination(_ destination: OrdersViews) -> some View {
        switch destination {
        case .ordersView:
            OrdersView()
        case let .orderView(id):
            OrderView(id: id)
        }
    }
}
