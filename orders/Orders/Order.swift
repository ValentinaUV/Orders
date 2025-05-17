//
//  Order.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

struct Order: Codable, Identifiable {
    let id: Int
    let description: String?
    let price: Double
    let customer_id: Int
    let image_url: String?
    let status: String
    let customer: Customer?
}
