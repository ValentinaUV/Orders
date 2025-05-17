//
//  LocationManager.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import MapKit
import CoreLocation

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.7712, longitude: 23.6236)
    
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.7712, longitude: 23.6236),
        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        print("Location requested")
        if isLocationAuthorized() {
            locationManager.requestLocation()
            self.mapRegion = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        } else {
            print("Location not authorized")
        }
    }
    
    func isLocationAuthorized() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            return true
        default:
            return false
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard .authorizedWhenInUse == manager.authorizationStatus else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something went wrong with MAP location: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        
        self.location = location.coordinate
    }
}
