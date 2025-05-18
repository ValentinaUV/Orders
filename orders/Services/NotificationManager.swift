//
//  NotificationManager.swift
//  orders
//
//  Created by Valentina Ungurean on 18.05.2025.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {

    static let shared = NotificationManager()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        requestAuthorization()
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
//                 Register for remote notifications if needed
//                 UIApplication.shared.registerForRemoteNotifications()
            } else if let error = error {
                print("Notification permission denied: \(error.localizedDescription)")
            } else {
                print("Notification permission denied or user dismissed the prompt.")
            }
        }
    }

    func scheduleOrderStatusChangeNotification(orderId: Int, newStatus: OrderStatus) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                print("Notification permission not authorized. Cannot schedule notification for order \(orderId).")
                return
            }

            let content = UNMutableNotificationContent()
            content.title = "Order #\(orderId) Status Updated"
            content.body = "Your order status is now: \(newStatus.rawValue.capitalized)"
            content.sound = UNNotificationSound.default
            content.userInfo = ["orderId": orderId]

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIdentifier = "order_status_change_\(orderId)_\(Date().timeIntervalSinceReferenceDate)"
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification for order \(orderId): \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully for order \(orderId).")
                }
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    // Called when the app is in the foreground and a notification is about to be delivered
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification received in foreground: \(notification.request.identifier)")
        completionHandler([.banner, .sound, .badge])
    }

    // Called when the user taps on a notification or performs an action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification tapped: \(response.notification.request.identifier)")
        let userInfo = response.notification.request.content.userInfo
        if let orderId = userInfo["orderId"] as? Int {
            print("Notification for order ID \(orderId) tapped.")
        }

        completionHandler()
    }
}
