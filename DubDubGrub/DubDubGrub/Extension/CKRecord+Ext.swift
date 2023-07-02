//
//  CKRecord+Ext.swift
//  DubDubGrub
//
//  Created by wizz on 7/2/23.
//

import CloudKit

extension CKRecord{
    func convertToDDGLocation() -> DDGLocation { DDGLocation(record: self) }
    func convertToDDGProfile() -> DDGProfile { DDGProfile(record: self) }
}
