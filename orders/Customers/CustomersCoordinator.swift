//
//  CustomersCoordinator.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI
import MapKit

enum CustomersViews: Hashable, Equatable {
    case customers
    case customerMapView(customer: Customer)
}

class CustomersCoordinator: ObservableObject{
    @Published var path = NavigationPath()

    func clear() {
        path = .init()
    }
    
    func goBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func goToCustomersView() {
        clear()
    }
    
    func goToCustomerMapView(customer: Customer) {
        path.append(CustomersViews.customerMapView(customer: customer))
    }
}

enum CustomersViewFactory {
    
    @ViewBuilder
    static func viewForDestination(_ destination: CustomersViews) -> some View {
        switch destination {
        case .customers:
            CustomersView()
        case let .customerMapView(customer):
            if let lat = customer.latitude, let long = customer.longitude {
                let location = Location(name: customer.name,
                                        coordinate: CLLocationCoordinate2D(
                                            latitude: lat,
                                            longitude: long))
                MapView(annotations: [location], selectedMarker: location)
            }
        }
    }
}
