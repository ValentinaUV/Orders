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
    
    @State var annotations: [CustomAnnotation] = []

    @State var selectedMarker: CustomAnnotation?
    
    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    userTrackingMode: .constant(.none),
                    annotationItems: annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        VStack {
                            Image(.mappinActive)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .font(.title)
                                .onTapGesture {
                                    selectedMarker = nil
                                    selectedMarker = annotation
                                }
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
                            viewModel.showDistanceModal = false
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
                        
                        if viewModel.route == nil {
                            Button(action: {
                                viewModel.centerOnUserLocation()
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
                            .disabled(viewModel.userLocation == nil)
                            .opacity(viewModel.userLocation == nil ? 0.5 : 1.0)
                        }
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
                if let location = selectedMarker {
                    viewModel.getDirections(destination: location)
                }
            }
            .onChange(of: selectedMarker) { location in
                if let location {
                    viewModel.getDirections(destination: location)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $viewModel.showDistanceModal) {
            if let distance = viewModel.routeDistance {
                VStack(spacing: 0) {
                    Text("Route Distance: \(formattedDistance(distance))")
                        .padding(20)

                    Button("Reset") {
                        withAnimation {
                            viewModel.showDistanceModal = false
                            selectedMarker = nil
                            viewModel.route = nil
                        }
                    }
                    .padding()
                    Spacer()
                }
                .padding(.top, 20)
                .font(.headline)
                .presentationDetents([.height(150), .height(151)])
                .presentationBackgroundInteraction(.enabled)
            }
        }
    }
    
    func formattedDistance(_ distance: CLLocationDistance) -> String {
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale // Uses miles or kilometers based on locale
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter.string(from: measurement)
    }
}
