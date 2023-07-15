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
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus){
        //Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID  else { return }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let record):
                    //Create a reference to the location
                    switch checkInStatus {
                        case .checkedIn:
                            record[DDGProfile.KIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                        case .checkedOut:
                            record[DDGProfile.KIsCheckedIn] = nil
                    }
                    //Save the updated profile to CloudKit
                    CloudKitManager.shared.save(record: record) { result in
                        switch result {
                            case .success(_):
                                //update our checkedinProfiles array
                                print("Checked in/out Successfully")
                            case .failure(let failure):
                                print("❌ Error saving recording ")
                        }
                    }
                case .failure(let failure):
                    print("❌ Error fetching recording ")
            }
        }
        
        
    }
}
