//
//  OnboardView.swift
//  DubDubGrub
//
//  Created by wizz on 7/6/23.
//

import SwiftUI

struct OnboardView: View {
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button{}label: {
                   XDismissButton()
                }
            }
            Spacer()
            LogoView(frameWidth: 250).padding(.bottom)
            VStack(alignment: .leading, spacing: 32){
                OnboardInfoView(image: "building.2.crop.circle", title: "Restaurant Locations", description: "Find places to dine around the convention center")
                OnboardInfoView(image: "checkmark.circle", title: "Check In", description: "Let other iOS dev know where you are")
                OnboardInfoView(image: "person.2.circle", title: "Find Friends", description: "See where other iOS dev are and join the party")
            }
            .padding(.horizontal, 40)
            Spacer()
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
    }
}

struct OnboardInfoView: View {
    var image: String
    var title: String
    var description: String
    var body: some View {
        HStack(spacing: 26){
            Image(systemName: image)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.brandPrimary)
            VStack(alignment: .leading, spacing: 4){
                Text(title).bold()
                Text(description)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
        }
    }
}
