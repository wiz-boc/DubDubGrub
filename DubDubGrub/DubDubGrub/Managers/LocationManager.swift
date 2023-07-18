//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by wizz on 7/4/23.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var selectedLocation: DDGLocation?
    @Published var locations: [DDGLocation] = []
}
