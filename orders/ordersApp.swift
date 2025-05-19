//
//  ordersApp.swift
//  orders
//
//  Created by Valentina Ungurean on 15.05.2025.
//

import SwiftUI
import FactoryKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    @Injected(\.notificationManager) private var notificationManager: NotificationManager
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        notificationManager.requestAuthorization()
        return true
    }
}

@main
struct ordersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var tabSelection: TabsEnum = .orders
    @ObservedObject var ordersCoordinator = Container.shared.ordersCoordinator()
    @ObservedObject var customersCoordinator = Container.shared.customersCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView(tabSelection: $tabSelection)
                .environmentObject(ordersCoordinator)
                .environmentObject(customersCoordinator)
                .onOpenURL { incomingURL in
                    print("App was opened via URL: \(incomingURL)")
                    handleIncomingURL(incomingURL)
                }
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }
        
        if url.scheme == AppConfig.deepLinkScheme {
            handleDeeplinks(components)
            return
        }
    }
    
    private func handleDeeplinks(_ components: URLComponents) {
        if let action = components.host {
            if action == "orders", let orderId = components.queryItems?.first(where: { $0.name == "id" })?.value, let intId = Int(orderId) {
                tabSelection = .orders
                ordersCoordinator.goToOrderView(id: intId)
                return
            }
            
            print("Unknown URL, we can't handle this one!")
        }
    }
}
