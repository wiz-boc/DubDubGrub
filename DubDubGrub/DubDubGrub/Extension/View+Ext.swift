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
}
