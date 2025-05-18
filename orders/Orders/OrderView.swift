//
//  OrderView.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI

struct OrderView: View {
    let id: Int
    @StateObject var viewModel = OrderViewModel()
    let currency = "Lei"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if let order = viewModel.order {
                    if let imageUrl = order.image_url, let url = URL(string: imageUrl) {
                        ImageView(url: url, maxHeight: 400)
                    }
                    
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
                    
                    HStack(spacing: 10) {
                        Text("Customer Name:")
                        Spacer()
                        Text(order.customer?.name ?? "")
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.getOrder(id: id)
        }
    }
}
