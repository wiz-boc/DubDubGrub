//
//  ProfileView.swift
//  DubDubGrub
//
//  Created by wizz on 6/24/23.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            VStack{
                
                HStack(spacing: 16){
                    ProfileImageView(image: viewModel.avatar).onTapGesture { viewModel.isShowingPhotoPicker = true }
                    
                    VStack(spacing: 1){
                        TextField("First Name", text: $viewModel.firstName).ProfileNameStyle()
                        TextField("Last Name", text: $viewModel.lastName).ProfileNameStyle()
                        TextField("Company Name", text: $viewModel.companyName)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.vertical)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                
                
                VStack(alignment: .leading, spacing: 8){
                    HStack{
                        CharactersRemainView(currentCount: viewModel.bio.count).accessibilityAddTraits(.isHeader)
                        Spacer()
                        
                        if viewModel.isCheckedIn {
                            Button{
                                viewModel.checkOut()
                            } label: {
                                CheckOutButton()
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    
                    BioTextEditor(text: $viewModel.bio)
                    
                }.padding(.horizontal, 16)
                
                Spacer()
                
                Button{
                    viewModel.determineButtonAction()
                } label: {
                    DDGButton(title: viewModel.buttonTitle)
                }
                .padding(.bottom)
            }
            
            if viewModel.isLoading { LoadingView() }
            
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(DeviceTypes.isiPhone8Standard ? .inline : .automatic)
        .toolbar(content: {
            Button{ dismissKeyboard() } label: { Image(systemName: "keyboard.chevron.compact.down") }
        })
        .onAppear{
            viewModel.getProfile()
            viewModel.getCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem) { $0.alert }
        .sheet(isPresented: $viewModel.isShowingPhotoPicker) { PhotoPicker(image: $viewModel.avatar) }
    }
    
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{ ProfileView() }
    }
}


fileprivate struct NameBackgroundView: View {
    var body: some View {
        Color(.secondarySystemBackground)
            .frame(height: 130)
            .cornerRadius(12)
            .padding(.horizontal)
    }
}

fileprivate struct ProfileImageView: View {
    
    var image: UIImage
    var body: some View {
        ZStack{
            AvatarView(image: image, size: 84)
            
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .offset(y: 30)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(Text("Profile Photo"))
        .accessibilityHint(Text("Open iPhone's photo picker"))
        .padding(.leading,12)
        
        
    }
}

fileprivate struct CharactersRemainView: View {
    var currentCount: Int
    var body: some View {
        Text("Bio: ")
            .font(.callout)
            .foregroundColor(.secondary)
        +
        Text("\(100 - currentCount)")
            .bold()
            .font(.callout)
            .foregroundColor( currentCount <= 100 ? .brandPrimary : Color(.systemPink))
        +
        Text(" Characters Remain")
            .font(.callout)
            .foregroundColor(.secondary)
    }
}

struct CheckOutButton: View {
    var body: some View {
        Label("Check Out", systemImage: "mappin.and.ellipse")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)
            .padding(10)
            .frame(height: 28)
            .background(Color.grubRed)
            .cornerRadius(8)
            .accessibilityLabel(Text("Check out of current location"))
    }
}

struct BioTextEditor: View {
    var text: Binding<String>
    var body: some View {
        TextEditor(text: text)
            .frame(height: 100)
            .overlay { RoundedRectangle(cornerRadius: 8).stroke(.secondary, lineWidth: 1) }
            .accessibilityHint(Text("This textfield is for your bio and has a 100 character limit"))
    }
}
