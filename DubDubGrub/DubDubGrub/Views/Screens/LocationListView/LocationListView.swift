//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by wizz on 6/24/23.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationListViewModel()
    var body: some View {
        NavigationView {
            List{
                ForEach(locationManager.locations){ location in
                    NavigationLink { LocationDetailView(viewModel: LocationDetailViewModel(location: location)) } label: { LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
            .onAppear{ viewModel.getCheckedInProfilesDictionary() }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
            .environmentObject(LocationManager())
    }
}



