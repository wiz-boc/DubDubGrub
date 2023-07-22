//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/18/23.
//

import CoreLocation
import SwiftUI

extension AppTabView {
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        
        @Published var isShowingOnboardView = false
        @Published var alertItem: AlertItem?
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet{ isShowingOnboardView = hasSeenOnboardView }
        }
        
        var deviceLocationManager: CLLocationManager?
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        func runStartUpChecks(){
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            } else {
                checkIfLocationServicesIsEnable()
            }
        }
        
        func checkIfLocationServicesIsEnable() {
            if CLLocationManager.locationServicesEnabled(){
                self.deviceLocationManager = CLLocationManager()
                self.deviceLocationManager!.delegate = self
            } else {
                self.alertItem = AlertContext.locationDisable
            }
        }
        
        func checkLocationAuthorization(){
            guard let deviceLocationManager = deviceLocationManager else { return }
            switch deviceLocationManager.authorizationStatus {
                case .notDetermined:
                    deviceLocationManager.requestWhenInUseAuthorization()
                case .restricted:
                    alertItem = AlertContext.locationRestricted
                case .denied:
                    alertItem = AlertContext.locationDenied
                case .authorizedAlways, .authorizedWhenInUse:
                    break
                @unknown default:
                    break
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
        
    }
    
}
