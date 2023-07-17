//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/17/23.
//

import CloudKit

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
}
