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
}
