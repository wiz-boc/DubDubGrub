//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/2/23.
//

import MapKit
import CloudKit
import SwiftUI

extension LocationMapView {
    
    final class LocationMapViewModel: NSObject,ObservableObject {
        
        @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
        @Published var isShowingDetailView = false
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        @Published var alertItem: AlertItem?
        
        func getLocations(for locationManager: LocationManager){
            CloudKitManager.shared.getLocations { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch(result){
                        case .success(let locations):
                            locationManager.locations = locations
                        case .failure(_):
                            self.alertItem = AlertContext.unableToGetLocations
                    }
                }
                
            }
        }
        
        func getCheckedInCounts(){
            CloudKitManager.shared.getCheckedInProfilesCount { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                        case .success(let checkedInProfiles):
                            self.checkedInProfiles = checkedInProfiles
                        case .failure(_):
                            alertItem = AlertContext.checkedInCount
                    }
                }
            }
        }
        
        @ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
        
    }
    
}
