//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by wizz on 6/26/23.
//

import SwiftUI

struct LocationDetailView: View {
    
    @ObservedObject var viewModel: LocationDetailViewModel
    
    var body: some View {
        ZStack{
            VStack(spacing: 16){
                BannerImageView(image: viewModel.location.createBannerImage())
                
                HStack{
                    AddressView(address: viewModel.location.address)
                    Spacer()
                }
                .padding(.horizontal)
                
                DescriptionView(description: viewModel.location.description)
                
                ZStack{
                    Capsule()
                        .frame(height: 80)
                        .foregroundColor(Color(.secondarySystemBackground))
                    
                    HStack(spacing: 20){
                        Button{
                            viewModel.getDirectionToLocation()
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "location.fill")
                        }
                        
                        Link(destination: URL(string: viewModel.location.websiteURL)!, label: {
                            LocationActionButton(color: .brandPrimary, imageName: "network")
                        })
                        
                        Button{
                            viewModel.callLocation()
                        } label: {
                            LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
                        }
                        if CloudKitManager.shared.profileRecordID != nil {
                            Button{
                                viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                            } label: {
                                
                                LocationActionButton(color: viewModel.isCheckedIn ? .grubRed : .brandPrimary, imageName: viewModel.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark")
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                Text("Who's here?")
                    .bold()
                    .font(.title2)
                
                ZStack{
                    if viewModel.checkedInProfiles.isEmpty {
                        Text("Nobody's here 😔").bold().font(.title2).foregroundColor(.secondary).padding(.top,30)
                    }else {
                        ScrollView {
                            LazyVGrid(columns: viewModel.columns) {
                                ForEach(viewModel.checkedInProfiles){ profile in
                                    FirstNameAvatarView(profile: profile)
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.isShowingProfileModal = true
                                            }
                                            
                                        }
                                }
                            }
                        }
                    }
                    
                    if viewModel.isLoading { LoadingView() }
                }
            
                Spacer()
            }
            
            if viewModel.isShowingProfileModal {
                Color(.systemBackground)
                    .ignoresSafeArea().opacity(0.9)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                
                ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal, profile: DDGProfile(record: MockData.profile))
                    .transition(.opacity.combined(with: .slide))
                    .zIndex(2)
            }
        }
        .onAppear{
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.location)))
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
    var profile: DDGProfile
    
    var body: some View{
        VStack{
            AvatarView(image: profile.createAvatarImage(), size: 64)
            Text(profile.firstName)
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
