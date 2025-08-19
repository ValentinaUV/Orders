//
//  MapViewModel.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI
import MapKit

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 46.7712, longitude: 23.6236),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    @Published var userLocation: CLLocation?
    @Published var annotations: [CustomAnnotation] = []
    @Published var isRoutingInProgress = false
    @Published var isRoutingDone = true
    @Published var route: MKRoute?
    @Published var routeDistance: CLLocationDistance?
    @Published var showDistanceModal = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Handle denied access
            break
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            
            region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            
            updateCurrentLocationAnnotation(location: location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func updateCurrentLocationAnnotation(location: CLLocation) {
        annotations.removeAll { !$0.isDestination }
        
        let currentLocationAnnotation = CustomAnnotation(
            coordinate: location.coordinate,
            title: "My Location",
            isDestination: false
        )
        annotations.append(currentLocationAnnotation)
    }
    
    func centerOnUserLocation() {
        guard let userLocation = userLocation else {
            checkLocationAuthorization()
            return
        }
        
        withAnimation {
            region = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
    
    func getDirections(destination: CustomAnnotation) {
        guard let userLocation = userLocation else {
            checkLocationAuthorization()
            return
        }
        
        if isRoutingInProgress || !isRoutingDone {
            return
        }
        isRoutingInProgress = true
        
        annotations.removeAll { $0.isDestination }
        var destinationAnnotation = destination
        destinationAnnotation.isDestination = true
        annotations.append(destinationAnnotation)
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            self.isRoutingInProgress = false
            
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                return
            }
            
            if let route = response?.routes.first {
                self.route = route
                self.routeDistance = route.distance
                self.createRegionForRoute(route: route)
                self.isRoutingDone = true
                self.showDistanceModal = true
            }
        }
    }

    private func createRegionForRoute(route: MKRoute) {
        let rect = route.polyline.boundingMapRect
        
        let padding = 0.3
        let paddedRect = MKMapRect(
            x: rect.origin.x - rect.size.width * padding,
            y: rect.origin.y - rect.size.height * padding,
            width: rect.size.width * (1 + 2 * padding),
            height: rect.size.height * (1 + 2 * padding)
        )
        
        // Convert MKMapRect to MKCoordinateRegion
        let region = MKCoordinateRegion(paddedRect)
        self.region = region
    }
}
 
struct CustomAnnotation: Identifiable, Equatable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    var isDestination: Bool
    
    static func == (lhs: CustomAnnotation, rhs: CustomAnnotation) -> Bool {
        return lhs.id == rhs.id &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude &&
        lhs.title == rhs.title &&
        lhs.isDestination == rhs.isDestination
    }
}
 
extension MKCoordinateRegion {
    init(_ mapRect: MKMapRect) {
        let center = mapRect.midPoint
        
        // Calculate span based on the map rect size
        let topLeft = MKMapPoint(x: mapRect.minX, y: mapRect.minY).coordinate
        let bottomRight = MKMapPoint(x: mapRect.maxX, y: mapRect.maxY).coordinate
        
        let latDelta = abs(topLeft.latitude - bottomRight.latitude)
        let lonDelta = abs(topLeft.longitude - bottomRight.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        self.init(center: center, span: span)
    }
}
 
extension MKMapRect {
    var midPoint: CLLocationCoordinate2D {
        let center = MKMapPoint(x: self.midX, y: self.midY)
        return center.coordinate
    }
}
