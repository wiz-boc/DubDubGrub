//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by wizz on 7/2/23.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext {
    //MARK: - MapView Errors
    static let unableToGetLocations = AlertItem(title: Text("Locations Errors"), message: Text("Unable to retrieve locations at this time.\nPlease try again"), dismissButton: .default(Text("Ok")))
    static let locationRestricted = AlertItem(title: Text("Location restricted"), message: Text("Your location is restricted."), dismissButton: .default(Text("Ok")))
    static let locationDenied = AlertItem(title: Text("Location Denied"), message: Text("Dub Dub does not have permission to access your location."), dismissButton: .default(Text("Ok")))
    static let locationDisable = AlertItem(title: Text("Location Disable"), message: Text("Your phone's location services are disabled."), dismissButton: .default(Text("Ok")))
    
    //MARK: - ProfileVIew Errors
    static let invalidProfile = AlertItem(title: Text("Invalid Profile"), message: Text("All fields are required as well as a profle photo. Your bio must be < 100 characters.\n Please try again"), dismissButton: .default(Text("Ok")))
}
