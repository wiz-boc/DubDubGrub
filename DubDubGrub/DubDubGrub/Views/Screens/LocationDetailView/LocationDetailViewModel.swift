//
//  locationDetailViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/14/23.
//

import SwiftUI
import MapKit


final class LocationDetailViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var isShowingProfileModal = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var location: DDGLocation
    
    init(location: DDGLocation){
        self.location = location
    }
    
    func getDirectionToLocation(){
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    func callLocation(){
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        UIApplication.shared.open(url)
    }
}
