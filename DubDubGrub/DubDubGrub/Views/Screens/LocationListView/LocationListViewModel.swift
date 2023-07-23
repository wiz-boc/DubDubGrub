//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/17/23.
//

import CloudKit
import SwiftUI

extension LocationListView {
    final class LocationListViewModel: ObservableObject {
        
        @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        @Published var alertItem: AlertItem?
        func getCheckedInProfilesDictionary(){
            CloudKitManager.shared.getCheckedInProfilesDictionary { result in
                DispatchQueue.main.async { [self] in
                    switch result {
                        case .success(let profiles):
                            self.checkedInProfiles = profiles
                        case .failure(_):
                            alertItem = AlertContext.unableToGetAllCheckInProfile
                    }
                }
                
            }
        }
        
        func createVoiceOverSummary(for location: DDGLocation) -> String {
            let count = checkedInProfiles[location.id, default: []].count
            let personPlurality = count == 1 ? "person" : "people"
            
            return "\(location.name) \(count) \(personPlurality) checked in"
        }
        
        @ViewBuilder func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View {
            if sizeCategory >= .accessibilityMedium {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
    }
}
