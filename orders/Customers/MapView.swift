//
//  MapView.swift
//  orders
//
//  Created by Valentina Ungurean on 17.05.2025.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @EnvironmentObject var customersCoordinator: CustomersCoordinator
    @ObservedObject private var locationManager = LocationManager()
    @State var annotations: [Location] = []
    
    @State var selectedMarker: Location
    
    @State private var centerToUserLocation = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(
                coordinateRegion: $locationManager.mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .constant(.none),
                annotationItems: annotations
            ) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    if annotation.id == selectedMarker.id {
                        ZStack {
                            Image(.mappinActive)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .shadow(radius: 10)
                        }.accessibilitySortPriority(100)
                            
                    } else {
                        Image(.mappin)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .shadow(radius: 10)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            
            VStack {
                HStack(spacing: 12) {
                    Button(action: {
                        customersCoordinator.goBack()
                    }, label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: .black.opacity(0.08), radius: 2.5, x: 5, y: 5)
                            .overlay {
                                HStack {
                                    Spacer()
                                    Image(systemName: "chevron.backward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 20)
                                        .padding(.trailing, 3)
                                    Spacer()
                                }
                            }
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        locationManager.requestLocation()
                    }, label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 40, height: 40)
                            .shadow(color: .black.opacity(0.08), radius: 2.5, x: 5, y: 5)
                            .overlay {
                                HStack {
                                    Spacer()
                                    Image(.myLocation)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 22.8)
                                    Spacer()
                                }
                            }
                    })
                }
                
                Spacer()
            }
            .padding(.horizontal, 13)
        }
        .onAppear {
            centerToUserLocation = false
            locationManager.mapRegion = .init(
                center: selectedMarker.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
//            .onChange(of: locationManager.location) { newValue in
//                if centerToUserLocation {
//                    locationManager.mapRegion = .init(center: newValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                } else {
//                    centerToUserLocation = true
//                }
//            }
        
//            .animation(.spring, value: locationManager.mapRegion.center)
        .animation(.spring, value: locationManager.mapRegion.span.latitudeDelta)
    }
}
