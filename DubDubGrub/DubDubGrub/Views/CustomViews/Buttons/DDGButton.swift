//
//  DDGButton.swift
//  DubDubGrub
//
//  Created by wizz on 6/30/23.
//

import SwiftUI

struct DDGButton: View {
    
    var title: String
    var color: Color = Color.brandPrimary
    var body: some View {
        Text(title)
            .bold()
            .frame(width: 280, height: 44)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct DDGButton_Previews: PreviewProvider {
    static var previews: some View {
        DDGButton(title: "Create Profile")
    }
}
