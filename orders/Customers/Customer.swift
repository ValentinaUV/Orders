//
//  Customer.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

struct Customer: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let latitude: Double?
    let longitude: Double?
}
