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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        NavigationView {
            List{
                ForEach(locationManager.locations){ location in
                    NavigationLink { viewModel.createLocationDetailView(for: location, in: dynamicTypeSize) }
                label: { LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
                }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
            .onAppear{ viewModel.getCheckedInProfilesDictionary() }
            .alert(item: $viewModel.alertItem) { $0.alert }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
            .environmentObject(LocationManager())
    }
}



