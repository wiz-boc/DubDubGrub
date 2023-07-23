//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by wizz on 6/30/23.
//

import SwiftUI

extension View {
    func ProfileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
    
//    func playHaptic(){
//       UINotificationFeedbackGenerator().notificationOccurred(.success)
//    }
    
    func embedInScrollView() -> some View {
        GeometryReader { geometry in
            ScrollView {
                self.frame(minHeight: geometry.size.height, maxHeight: .infinity)
            }
        }
    }
    
    func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
