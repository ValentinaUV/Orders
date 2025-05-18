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
