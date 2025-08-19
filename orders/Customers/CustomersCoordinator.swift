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
    case allCustomersMapView(customers: [Customer])
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
    
    func goToAllCustomersMapView(customers: [Customer]) {
        path.append(CustomersViews.allCustomersMapView(customers: customers))
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
                let location = CustomAnnotation(
                    coordinate: CLLocationCoordinate2D(
                        latitude: lat,
                        longitude: long
                    ),
                    title: customer.name,
                    isDestination: true
                )
                MapView(annotations: [location], selectedMarker: location)
            }
        case let .allCustomersMapView(customers):
            let annotations: [CustomAnnotation] = customers.compactMap { customer in
                if let lat = customer.latitude, let long = customer.longitude {
                    return CustomAnnotation(
                        coordinate: CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: long
                        ),
                        title: customer.name,
                        isDestination: false
                    )
                }
                return nil
            }
            MapView(annotations: annotations, selectedMarker: nil)
        }
    }
}
