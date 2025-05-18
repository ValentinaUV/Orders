//
//  CustomerCardView.swift
//  orders
//
//  Created by Valentina Ungurean on 18.05.2025.
//

import SwiftUI

struct CustomerCardView: View {
    let customer: Customer
    @EnvironmentObject var customersCoordinator: CustomersCoordinator
    
    @StateObject var viewModel = CustomerCardViewModel()
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 0) {
                    Text("Name:")
                    Spacer()
                    Text(customer.name)
                }
                
                if let lat = customer.latitude, let long = customer.longitude {
                    HStack(spacing: 10) {
                        Text("Latitude:")
                        Spacer()
                        Text("\(lat)")
                    }
                    
                    HStack(spacing: 10) {
                        Text("Longitude:")
                        Spacer()
                        Text("\(long)")
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            customersCoordinator.goToCustomerMapView(customer: customer)
                        }, label: {
                            Text("Show on map")
                        }
                        )
                    }
                    
                    HStack {
                        if viewModel.orders.isEmpty {
                            Spacer()
                            Button(action: {
                                viewModel.getOrders(for: customer)
                            }, label: {
                                Text("Show Orders")
                            })
                        } else {
                            Text("Orders:")
                            Spacer()
                            VStack {
                                ForEach(viewModel.orders, id: \.id) { order in
                                    Button(action: {
                                        if let url = URL(string: AppConfig.ordersDeepLink+"?id=\(order.id)") {
                                            UIApplication.shared.open(url)
                                        }
                                    }, label: {
                                        Text("order nr: \(order.id)")
                                    })
                                }
                            }
                        }
                    }
                }
            }
            .padding(10)
        }
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(.gray20)
        }
        .contentShape(Rectangle())
    }
}
