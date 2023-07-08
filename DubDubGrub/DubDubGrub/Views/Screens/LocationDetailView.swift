//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by wizz on 6/26/23.
//

import SwiftUI

struct LocationDetailView: View {
    
    var location: DDGLocation
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack(spacing: 16){
            BannerImageView(image: location.createBannerImage())
            
            HStack{
                AddressView(address: location.address)
                
                Spacer()
            }
            .padding(.horizontal)
            
            DescriptionView(description: location.description)
            
            ZStack{
                Capsule()
                    .frame(height: 80)
                    .foregroundColor(Color(.secondarySystemBackground))
                
                HStack(spacing: 20){
                    Button{
                        
                    } label: {
                        LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                    }
                    
                    Link(destination: URL(string: location.websiteURL)!, label: {
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
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    FirstNameAvatarView(image: PlaceholderImage.avatar, firstName: "Wiz")
                    FirstNameAvatarView(image: PlaceholderImage.avatar,firstName: "Kenroy")
                    FirstNameAvatarView(image: PlaceholderImage.avatar,firstName: "Mason")
                    FirstNameAvatarView(image: PlaceholderImage.avatar,firstName: "Kenny G")
                    FirstNameAvatarView(image: PlaceholderImage.avatar,firstName: "Wiz")
                    FirstNameAvatarView(image: PlaceholderImage.avatar,firstName: "Kenroy")
                    FirstNameAvatarView(image: PlaceholderImage.avatar,firstName: "Mason")
                    FirstNameAvatarView(image: PlaceholderImage.avatar,firstName: "Kenny G")
                }
            }
            
            Spacer()
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LocationDetailView(location: DDGLocation(record: MockData.location))
        }
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
    var image: UIImage
    var firstName: String
    
    var body: some View{
        VStack{
            AvatarView(image: image, size: 64)
            Text(firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}

struct BannerImageView: View {
    var image: UIImage
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .padding(.top)
    }
}

struct AddressView: View {
var address: String
    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct DescriptionView: View {
    
var description: String
    var body: some View {
        Text(description)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
    }
}
