//
//  DubDubGrubApp.swift
//  DubDubGrub
//
//  Created by wizz on 6/24/23.
//

import SwiftUI

@main
struct DubDubGrubApp: App {
    let locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}
