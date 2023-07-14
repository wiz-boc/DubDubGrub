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
    
    //MARK: - ProfileView Errors
    static let invalidProfile = AlertItem(title: Text("Invalid Profile"), message: Text("All fields are required as well as a profile photo. Your bio must be < 100 characters.\n Please try again"), dismissButton: .default(Text("Ok")))
    static let noUserRecord = AlertItem(title: Text("No User Record"), message: Text("You must be sign in to iCloud on your phone to use DubDub grub\n Please sign in in settings"), dismissButton: .default(Text("Ok")))
    static let createProfileSuccess = AlertItem(title: Text("Profile Create successfully"), message: Text("You profile was successfully saved"), dismissButton: .default(Text("Ok")))
    static let createProfileFail = AlertItem(title: Text("Fail to Create Profile"), message: Text("We were unable to create your profile.\nPlease retry again"), dismissButton: .default(Text("Ok")))
    static let unableToGetProfile = AlertItem(title: Text("Unable to retrieve profile"), message: Text("We were unable to retrieve your profile.\nPlease retry again"), dismissButton: .default(Text("Ok")))
    static let updateProfileSuccess = AlertItem(title: Text("Profile Update Success!"), message: Text("Your DubDub Grub profile was succesfully update"), dismissButton: .default(Text("Ok")))
    static let updateProfileFailure = AlertItem(title: Text("Profile Update failed"), message: Text("We were unable to update your profile.\nPlease retry again"), dismissButton: .default(Text("Ok")))
    
    //MARK: - LocationDetail View Errors
    static let invalidPhoneNumber = AlertItem(title: Text("Invalid Phone Number"), message: Text("The number number is invalid"), dismissButton: .default(Text("Ok")))
}
