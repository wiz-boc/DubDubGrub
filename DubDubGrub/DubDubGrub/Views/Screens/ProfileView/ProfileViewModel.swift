//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/9/23.
//

import CloudKit

enum ProfileContext { case create, update }

final class ProfileViewModel: ObservableObject {
    
    @Published var firstName  = ""
    @Published var lastName  = ""
    @Published var companyName  = ""
    @Published var bio  = ""
    @Published var avatar = PlaceholderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var isLoading = false
    @Published var isCheckedIn = false
    @Published var alertItem: AlertItem?
    
    private var existingProfileRecord: CKRecord? { didSet { profileContext = .update } }
    var profileContext: ProfileContext = .create
    
    func isValidProfile() -> Bool {
        guard !firstName.isEmpty,!lastName.isEmpty,!companyName.isEmpty,!bio.isEmpty,avatar != PlaceholderImage.avatar,bio.count <= 100 else { return false }
        return true
    }
    
    func checkOut(){
        guard let profileID = CloudKitManager.shared.profileRecordID  else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileID) { result in
            
            switch result {
                case .success(let record):
                    record[DDGProfile.KIsCheckedIn] = nil
                    record[DDGProfile.KIsCheckedInNilCheck] = nil
                    CloudKitManager.shared.save(record: record) { [self] result in
                        DispatchQueue.main.async {
                            switch result {
                                case .success(_):
                                    isCheckedIn = false
                                case .failure(_):
                                    alertItem = AlertContext.unableToCheckInOrOut
                            }
                        }
                    }
                case .failure(_):
                    DispatchQueue.main.async { self.alertItem = AlertContext.unableToCheckInOrOut }
            }
        }
    }
    
    func createProfile(){
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        let profileRecord = createProfileRecord()
        
        guard let userRecord = CloudKitManager.shared.userRecord else { return }
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        showLoadingView()
        CloudKitManager.shared.batchSave(records: [userRecord,profileRecord]) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                hideLoadingView()
                switch result {
                    case .success(let records):
                        for record in records where record.recordType == RecordType.profile {
                            existingProfileRecord = record
                            CloudKitManager.shared.profileRecordID = record.recordID
                        }
                        
                        alertItem = AlertContext.createProfileSuccess
                    case .failure(_):
                        alertItem = AlertContext.createProfileFail
                }
            }
        }
        
    }
    
    func updateProfile(){
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        guard let profileRecord = existingProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        showLoadingView()
        CloudKitManager.shared.save(record: profileRecord) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                hideLoadingView()
                switch result {
                    case .success(_):
                        alertItem = AlertContext.updateProfileSuccess
                    case .failure(_):
                        alertItem = AlertContext.updateProfileFailure
                }
            }
            
        }
        
    }
    
    func getProfile(){
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
        let profileRecordID = profileReference.recordID
        
        showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                hideLoadingView()
                switch result {
                    case .success(let record):
                        existingProfileRecord = record
                        let profile = DDGProfile(record: record)
                        firstName = profile.firstName
                        lastName = profile.lastName
                        companyName = profile.companyName
                        bio = profile.bio
                        avatar = profile.createAvatarImage()
                    case .failure(_):
                        alertItem = AlertContext.unableToGetProfile
                }
            }
        }
        
    }
    
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        profileRecord[DDGProfile.kFirstName] = firstName
        profileRecord[DDGProfile.kLastName] = lastName
        profileRecord[DDGProfile.kCompanyName] = companyName
        profileRecord[DDGProfile.kBio] = bio
        profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
        
        return profileRecord
    }
    
    func getCheckedInStatus(){
        guard let profileRecordID = CloudKitManager.shared.profileRecordID  else { return }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { [self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let record):
                        if let _ = record[DDGProfile.KIsCheckedIn] as? CKRecord.Reference {
                            isCheckedIn = true
                        } else {
                            isCheckedIn = false
                        }
                    case .failure(_):
                        break
                }
            }
        }
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    
}
