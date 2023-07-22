//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by wizz on 6/24/23.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations){ location in
                //MapMarker(coordinate: location.location.coordinate, tint: .brandPrimary)
                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    DDGAnnotation(number: viewModel.checkedInProfiles[location.id, default: 0], location: location)
                        .accessibilityLabel(Text("Map Pin \(location.name) \(viewModel.checkedInProfiles[location.id, default: 0]) people checked in."))
                        .onTapGesture {
                            locationManager.selectedLocation = location
                                viewModel.isShowingDetailView = true
                        }
                }
            }
            .tint(.grubRed)
            .ignoresSafeArea()
            
            VStack {
                LogoView(frameWidth: 125).shadow(radius: 10)
//                    .accessibilityHidden(true)
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isShowingDetailView, content: {
            if let location = locationManager.selectedLocation {
                NavigationView{
                    viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: sizeCategory)
                        .toolbar{ Button("Dismiss", action: { viewModel.isShowingDetailView = false }) }
                }
                .tint(.brandPrimary)
            }
        })
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .onAppear{
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }
            viewModel.getCheckedInCounts()
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
            .environmentObject(LocationManager())
    }
}

