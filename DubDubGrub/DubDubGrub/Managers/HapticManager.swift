//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by wizz on 7/23/23.
//

import UIKit

struct HapticManager {
    static func playSuccess(){
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
