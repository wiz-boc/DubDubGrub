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


    @MainActor final class LocationDetailViewModel: ObservableObject {
        
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
        
        func determineColumns(for dynamicTypeSize: DynamicTypeSize) -> [GridItem] {
            let numberOfColumns = dynamicTypeSize >= .accessibility3 ? 1 : 3
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
            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    if let reference = record[DDGProfile.KIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = reference.recordID == location.id
                    } else {
                        isCheckedIn = false
                    }
                }
                catch{
                    alertItem = AlertContext.unableToGetCheckInStatus
                }
            }
        }
        
        func updateCheckInStatus(to checkInStatus: CheckInStatus){
            guard let profileRecordID = CloudKitManager.shared.profileRecordID  else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            showLoadingView()
            Task{
                do{
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    switch checkInStatus {
                        case .checkedIn:
                            record[DDGProfile.KIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                            record[DDGProfile.KIsCheckedInNilCheck] = 1
                        case .checkedOut:
                            record[DDGProfile.KIsCheckedIn] = nil
                            record[DDGProfile.KIsCheckedInNilCheck] = nil
                    }
                    let savedRecord = try await CloudKitManager.shared.save(record: record)
                    hideLoadingView()
                    HapticManager.playSuccess()
                    let profile = DDGProfile(record: savedRecord)
                    switch checkInStatus {
                        case .checkedIn:
                            checkedInProfiles.append(profile)
                        case .checkedOut:
                            checkedInProfiles.removeAll(where: { $0.id == profile.id})
                    }
                    isCheckedIn.toggle()
                    
                }catch{
                    hideLoadingView()
                    alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
        func getCheckedInProfiles(){
            showLoadingView()
            Task{
                do{
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                    hideLoadingView()
                }catch{
                    hideLoadingView()
                    alertItem =  AlertContext.unableToGetCheckInProfile
                }
            }
        }
        
        func show(_ profile: DDGProfile, in dynamicTypeSize: DynamicTypeSize){
            selectedProfile = profile
            if dynamicTypeSize >= .accessibility3 {
                isShowingProfileSheet = true
            }else{
                isShowingProfileModal = true
            }
        }
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }

