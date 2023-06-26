//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by wizz on 6/26/23.
//

import SwiftUI

struct LocationDetailView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView{
            VStack(spacing: 16){
                Image("default-banner-asset")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                
                HStack{
                    Label("234 Main Street", systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Text("This os a test description. This os a test description This os a test description This os a test description This os a test description This os a test description")
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal)
                
                ZStack{
                    Capsule()
                        .frame(height: 80)
                        .foregroundColor(Color(.secondarySystemBackground))
                    
                    HStack(spacing: 20){
                        Button{
                            
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                        }
                        
                        Link(destination: URL(string: "https://www.apple.com")!, label: {
                            LocationActionButton(color: .brandPrimary, imageName: "network")
                        })
                        
                        Button{
                            
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                        }
                        
                        Button{
                            
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "person.fill.checkmark")
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                Text("Who's here?")
                    .bold()
                    .font(.title2)
                
                LazyVGrid(columns: columns) {
                    FirstNameAvatarView(firstName: "Wiz")
                    FirstNameAvatarView(firstName: "Kenroy")
                    FirstNameAvatarView(firstName: "Mason")
                    FirstNameAvatarView(firstName: "Kenny G")
                    FirstNameAvatarView(firstName: "Wiz")
                    FirstNameAvatarView(firstName: "Kenroy")
                    FirstNameAvatarView(firstName: "Mason")
                    FirstNameAvatarView(firstName: "Kenny G")
                }
                
                Spacer()
            }
            .navigationTitle("Location Name")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView()
    }
}

struct LocationActionButton: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
            
        }
    }
}

struct FirstNameAvatarView: View {
    var firstName: String
    
    var body: some View{
        VStack{
            AvatarView(size: 64)
            Text(firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}
