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
    
    @StateObject private var viewModel = MapViewModel()
    
    @State var annotations: [Location] = []

    @State var selectedMarker: Location
    
    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.follow),
                    annotationItems: viewModel.annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        VStack {
                            Image(systemName: annotation.isDestination ? "mappin.circle.fill" : "location.circle.fill")
                                .foregroundColor(annotation.isDestination ? .red : .blue)
                                .font(.title)
                            Text(annotation.title)
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                    }
                }

                if let route = viewModel.route {
                    RouteMapView(route: route)
                }
                
                VStack {
                    HStack {
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
                        
//                        Button(action: {
//                            viewModel.centerOnUserLocation()
//                        }, label: {
//                            Circle()
//                                .fill(.white)
//                                .frame(width: 40, height: 40)
//                                .shadow(color: .black.opacity(0.08), radius: 2.5, x: 5, y: 5)
//                                .overlay {
//                                    HStack {
//                                        Spacer()
//                                        Image(.myLocation)
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(height: 22.8)
//                                        Spacer()
//                                    }
//                                }
//                        })
//                        .disabled(viewModel.userLocation == nil)
//                        .opacity(viewModel.userLocation == nil ? 0.5 : 1.0)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 10)
                    Spacer()
                }
            }
            
            .overlay(
                Group {
                    if viewModel.isRoutingInProgress {
                        ProgressView("Calculating route...")
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                }
            )
            .onAppear {
                viewModel.checkLocationAuthorization()
            }
            .onChange(of: viewModel.userLocation) { _ in
                viewModel.getDirections(destination: selectedMarker.coordinate)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}
