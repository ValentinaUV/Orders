//
//  Repository.swift
//  orders
//
//  Created by Valentina Ungurean on 16.05.2025.
//

import Foundation
import RealmSwift

class OrderObject: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var descriptionText: String?
    @Persisted var price: Double = 0.0
    @Persisted var customerId: Int = 0
    @Persisted var imageUrl: String?
    @Persisted var status: String
    @Persisted var customer: CustomerObject?
}

class CustomerObject: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String
    @Persisted var latitude: Double = 0.0
    @Persisted var longitude: Double = 0.0
}

protocol RepositoryProtocol {
    func saveOrders(orders: [Order])
    func saveCustomers(customers: [Customer])
    func updateOrderStatus(orderId: Int, to newStatus: String)
}

class Repository: RepositoryProtocol {
    
    func saveOrders(orders: [Order]) {
        do {
            let realm = try Realm()

            try realm.write {
                print("Starting Realm write transaction for orders...")
                for order in orders {
                    let orderObject = realm.create(OrderObject.self, value: ["id": order.id], update: .modified)
                    orderObject.descriptionText = order.description ?? ""
                    orderObject.price = order.price
                    orderObject.customerId = order.customer_id
                    orderObject.imageUrl = order.image_url ?? ""
                    orderObject.status = order.status

                    // If you had relationships, you would link them here
                    // e.g., find the customer object and assign it to orderObject.customer
                }
                print("Orders processed and saved to Realm.")
            }
            print("Orders data successfully saved to Realm.")

        } catch {
            print("Error saving orders data to Realm: \(error)")
        }
    }

    func saveCustomers(customers: [Customer]) {
        do {
            let realm = try Realm()

            try realm.write {
                 print("Starting Realm write transaction for customers...")
                for customer in customers {
                    let customerObject = realm.create(CustomerObject.self, value: ["id": customer.id], update: .modified)
                    customerObject.name = customer.name
                    customerObject.latitude = customer.latitude ?? 0.0
                    customerObject.longitude = customer.longitude ?? 0.0
                }
                 print("Customers processed and saved to Realm.")
            }
            print("Customers data successfully saved to Realm.")

        } catch {
            print("Error saving customers data to Realm: \(error)")
        }
    }
    
    func updateOrderStatus(orderId: Int, to newStatus: String) {
        do {
            let realm = try Realm()
            if let orderToUpdate = realm.object(ofType: OrderObject.self, forPrimaryKey: orderId) {
                try realm.write {
                    orderToUpdate.status = newStatus
                    print("Manually updated order \(orderId) status to \(newStatus) in Realm after simulated API call.")
                }
            }
        } catch {
            print("Error manually updating order status in Realm: \(error)")
        }
    }
}
