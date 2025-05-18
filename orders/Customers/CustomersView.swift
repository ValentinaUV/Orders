//
//  CustomersView.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI

struct CustomersView: View {
    @StateObject var viewModel = CustomersViewModel()
    
    var body: some View {
        VStack {
            CustomersList(viewModel: viewModel)
            .padding()
            .navigationDestination(for: CustomersViews.self) { destination in
                CustomersViewFactory.viewForDestination(destination)
            }
        }
        .onAppear {
            viewModel.getCustomers()
        }
        .toolbarRole(.editor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Customers")
    }
}

struct CustomersList: View {
    @ObservedObject var viewModel: CustomersViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach($viewModel.customers, id: \.id) { $customer in
                    CustomerCardView(customer: customer)
                }
            }
            .padding(.top, 6)
            
        }
        .padding(.bottom, 10)
        .scrollIndicators(.hidden)
    }
}

struct CustomerCardView: View {
    let customer: Customer
    @EnvironmentObject var customersCoordinator: CustomersCoordinator
    
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
                        Text("\(lat))")
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
