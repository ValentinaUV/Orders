//
//  OrdersView.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI

struct OrdersView: View {
    @StateObject var viewModel = OrdersViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            OrdersList(viewModel: viewModel)
                .padding()
        }
        .onAppear {
            viewModel.getOrders()
        }
        .toolbarRole(.editor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Orders")
    }
}

struct OrdersList: View {
    @ObservedObject var viewModel: OrdersViewModel
    @EnvironmentObject var ordersCoordinator: OrdersCoordinator
        
    var body: some View {
        ScrollView {
            VStack {
                ForEach($viewModel.orders, id: \.id) { $order in
                    OrderCardView(order: order)
                    .onTapGesture {
                        ordersCoordinator.goToOrderView(id: order.id)
                    }
                }
            }
            .padding(.top, 6)
            .navigationDestination(for: OrdersViews.self) { destination in
                OrdersViewFactory.viewForDestination(destination)
            }
        }
        .padding(.bottom, 10)
        .scrollIndicators(.hidden)
    }
}

struct OrderCardView: View {
    let currency = "Lei"
    let order: Order
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 0) {
                    Text("ID:")
                    Spacer()
                    Text("\(order.id)")
                }
                
                HStack(spacing: 10) {
                    Text("Description:")
                    Spacer()
                    Text(order.description ?? "")
                }
                .padding(.bottom, 4)
                
                HStack(spacing: 10) {
                    Text("Price:")
                    Spacer()
                    Text("\(order.price.toString) \(currency)")
                }
                
                HStack(spacing: 10) {
                    Text("Status:")
                    Spacer()
                    Text(order.status)
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
