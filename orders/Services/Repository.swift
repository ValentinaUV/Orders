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
    @Persisted var customer_id: Int = 0
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
    func getAllOrders() -> [Order]
    func getOrder(id: Int) -> Order?
    func getAllCustomers() -> [Customer]
    func getCustomer(id: Int) -> Customer?
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
                    orderObject.imageUrl = order.image_url ?? ""
                    orderObject.status = order.status

                    if let customer = realm.object(ofType: CustomerObject.self, forPrimaryKey: order.customer_id) {
                        orderObject.customer = customer
                        print("Linked order \(order.id) to customer \(order.customer_id).")
                    } else {
                        print("Customer with ID \(order.customer_id) not found in Realm for order \(order.id).")
                        orderObject.customer = nil
                    }
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
    
    func getAllOrders() -> [Order] {
        do {
            let realm = try Realm()
            let orderObjects = realm.objects(OrderObject.self)

            let orders = orderObjects.map { orderObject in
                self.convertToOrder(orderObject: orderObject)
            }
            return Array(orders)
        } catch {
            print("Error fetching all orders from Realm: \(error)")
            return []
        }
    }
    
    private func convertToOrder(orderObject: OrderObject) -> Order {
        var customer: Customer? = nil
        if let objCustomer = orderObject.customer {
            customer = Customer(
                id: objCustomer.id,
                name: objCustomer.name,
                latitude: objCustomer.latitude,
                longitude: objCustomer.longitude)
        }
        return Order(
            id: orderObject.id,
            description: orderObject.descriptionText,
            price: orderObject.price,
            customer_id: orderObject.customer_id,
            image_url: orderObject.imageUrl,
            status: orderObject.status,
            customer: customer
        )
    }
    
    func getOrder(id: Int) -> Order? {
        do {
            let realm = try Realm()
            if let orderObject = realm.object(ofType: OrderObject.self, forPrimaryKey: id) {
                return convertToOrder(orderObject: orderObject)
            } else {
                return nil
            }
        } catch {
            print("Error fetching order with ID \(id) from Realm: \(error)")
            return nil
        }
    }
    
    func getAllCustomers() -> [Customer] {
        do {
            let realm = try Realm()
            let customerObjects = realm.objects(CustomerObject.self)

            let customers = customerObjects.map { customerObject in
                self.convertToCustomer(customerObject: customerObject)
            }
            return Array(customers)
        } catch {
            print("Error fetching all customers from Realm: \(error)")
            return []
        }
    }
    
    private func convertToCustomer(customerObject: CustomerObject) -> Customer {
        Customer(
            id: customerObject.id,
            name: customerObject.name,
            latitude: customerObject.latitude,
            longitude: customerObject.longitude
        )
    }
    
    func getCustomer(id: Int) -> Customer? {
        do {
            let realm = try Realm()
            if let customerObject = realm.object(ofType: CustomerObject.self, forPrimaryKey: id) {
                return convertToCustomer(customerObject: customerObject)
            } else {
                return nil
            }
        } catch {
            print("Error fetching customer with ID \(id) from Realm: \(error)")
            return nil
        }
    }
}
