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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ZStack(alignment: .top){
            
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations){ location in
                //MapMarker(coordinate: location.location.coordinate, tint: .brandPrimary)
                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    DDGAnnotation(number: viewModel.checkedInProfiles[location.id, default: 0], location: location)
                        .onTapGesture {
                            locationManager.selectedLocation = location
                                viewModel.isShowingDetailView = true
                        }
                }
            }
            .tint(.grubRed)
            .ignoresSafeArea()
            
            LogoView(frameWidth: 125).shadow(radius: 10)
        }
        .sheet(isPresented: $viewModel.isShowingDetailView, content: {
            if locationManager.selectedLocation != nil {
                NavigationView{
                    viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: dynamicTypeSize)
                        .toolbar{ Button("Dismiss", action: { viewModel.isShowingDetailView = false }) }
                }
                .tint(.brandPrimary)
            }
        })
        .alert(item: $viewModel.alertItem) { $0.alert }
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
        LocationMapView().environmentObject(LocationManager())
    }
}

