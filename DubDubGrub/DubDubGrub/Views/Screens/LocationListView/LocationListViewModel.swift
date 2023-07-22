//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/17/23.
//

import CloudKit
import SwiftUI

final class LocationListViewModel: ObservableObject {
    
    @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
    
    func getCheckedInProfilesDictionary(){
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let profiles):
                        self.checkedInProfiles = profiles
                    case .failure(let failure):
                        print("Failure: \(failure.localizedDescription)")
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
