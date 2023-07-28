//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by wizz on 7/18/23.
//

import CoreLocation
import SwiftUI

extension AppTabView {
    final class AppTabViewModel: ObservableObject {
        
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet{ isShowingOnboardView = hasSeenOnboardView }
        }
        
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        func checkIfHasSeenOnboard(){
            if !hasSeenOnboardView { hasSeenOnboardView = true }
        }
        
    }
    
}
