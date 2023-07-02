//
//  MockData.swift
//  DubDubGrub
//
//  Created by wizz on 7/2/23.
//

import CloudKit


struct MockData {
    
    static var location: CKRecord {
        let record = CKRecord(recordType: "DDGLocation")
        record[DDGLocation.kName] = "Wizz's tasty food"
        record[DDGLocation.kAddress] = "Broken Hurst Dist."
        record[DDGLocation.kDescription] = "This is Kenroy big bad resturant in mandeville for family and friends"
        record[DDGLocation.kWebsiteURL] = "https://apple.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.KPhoneNumber] = "876-578-2550"
        
        return record
    }
}
