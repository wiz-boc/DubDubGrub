//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/2/23.
//

import MapKit


final class LocationMapViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    func getLocations(for locationManager: LocationManager){
        CloudKitManager.getLocations { [weak self] result in
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
}
