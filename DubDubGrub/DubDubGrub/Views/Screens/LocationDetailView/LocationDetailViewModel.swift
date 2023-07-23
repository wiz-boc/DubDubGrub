//
//  locationDetailViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/14/23.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }


    final class LocationDetailViewModel: ObservableObject {
        
        @Published var checkedInProfiles: [DDGProfile] = []
        @Published var alertItem: AlertItem?
        @Published var isShowingProfileModal = false
        @Published var isShowingProfileSheet = false
        @Published var isLoading = false
        @Published var isCheckedIn = false
        
        //let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        var location: DDGLocation
        var selectedProfile: DDGProfile?
        var buttonColor: Color { isCheckedIn ? .grubRed : .brandPrimary }
        var buttonImageTitle: String { isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
        var buttonA11yLabel: String { isCheckedIn ? "Check out of location" : "Check into location" }
        
        init(location: DDGLocation){ self.location = location }
        
        func determineColumns(for sizeCategory: ContentSizeCategory) -> [GridItem] {
            let numberOfColumns = sizeCategory >= .accessibilityMedium ? 1 : 3
            return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
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
        
        func getCheckedInStatus(){
            guard let profileRecordID = CloudKitManager.shared.profileRecordID  else { return }
            CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let record):
                            if let reference = record[DDGProfile.KIsCheckedIn] as? CKRecord.Reference {
                                isCheckedIn = reference.recordID == location.id
                            } else {
                                isCheckedIn = false
                            }
                        case .failure(let failure):
                            alertItem = AlertContext.unableToGetCheckInStatus
                    }
                }
            }
        }
        
        func updateCheckInStatus(to checkInStatus: CheckInStatus){
            guard let profileRecordID = CloudKitManager.shared.profileRecordID  else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            showLoadingView()
            CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
                
                switch result {
                    case .success(let record):
                        switch checkInStatus {
                            case .checkedIn:
                                record[DDGProfile.KIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                                record[DDGProfile.KIsCheckedInNilCheck] = 1
                            case .checkedOut:
                                record[DDGProfile.KIsCheckedIn] = nil
                                record[DDGProfile.KIsCheckedInNilCheck] = nil
                        }
                        
                        CloudKitManager.shared.save(record: record) { result in
                            DispatchQueue.main.async {
                                hideLoadingView()
                                switch result {
                                    case .success(let record):
                                        HapticManager.playSuccess()
                                        let profile = DDGProfile(record: record)
                                        switch checkInStatus {
                                            case .checkedIn:
                                                checkedInProfiles.append(profile)
                                            case .checkedOut:
                                                checkedInProfiles.removeAll(where: { $0.id == profile.id})
                                        }
                                        isCheckedIn.toggle()
                                    case .failure(let failure):
                                        alertItem = AlertContext.unableToCheckInOrOut
                                }
                            }
                        }
                    case .failure(let failure):
                        hideLoadingView()
                        alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
        func getCheckedInProfiles(){
            showLoadingView()
            CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let profiles):
                            checkedInProfiles = profiles
                        case .failure(let failure):
                            alertItem =  AlertContext.unableToGetCheckInProfile
                    }
                    hideLoadingView()
                }
                
            }
        }
        
        func show(_ profile: DDGProfile, in sizeCategory: ContentSizeCategory){
            selectedProfile = profile
            if sizeCategory >= .accessibilityMedium {
                isShowingProfileSheet = true
            }else{
                isShowingProfileModal = true
            }
        }
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }

