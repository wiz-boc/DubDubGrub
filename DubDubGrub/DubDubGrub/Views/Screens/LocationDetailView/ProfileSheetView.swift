//
//  ProfileSheetView.swift
//  DubDubGrub
//
//  Created by wizz on 7/22/23.
//

import SwiftUI

//Alternative Profile Modal View for larger dynamic type sizes
struct ProfileSheetView: View {
    var profile: DDGProfile
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20){
                Image(uiImage: PlaceholderImage.avatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .accessibilityHidden(true)
                
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .minimumScaleFactor(9)
                
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(Text("Works at \(profile.companyName)"))
                
                Text(profile.bio)
                    .accessibilityLabel(Text("Bio, \(profile.bio)"))
                
            }
        }
    }
}

struct ProfileSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSheetView(profile: DDGProfile(record: MockData.profile))
    }
}
