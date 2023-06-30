//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by wizz on 6/24/23.
//

import SwiftUI

struct LocationListView: View {
    var body: some View {
        NavigationView {
            List{
                ForEach(0..<10){ item in
                    NavigationLink { LocationDetailView() } label: { LocationCell() }
                        .padding(.horizontal,0)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .navigationTitle("Grub Spots")
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}



