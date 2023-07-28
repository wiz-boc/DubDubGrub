//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by wizz on 6/24/23.
//

import SwiftUI

struct AppTabView: View {

    @StateObject private var viewModel = AppTabViewModel()
    var body: some View {
        TabView() {
            LocationMapView().tabItem { Label("Map", systemImage: "map") }
            LocationListView().tabItem { Label("Locations", systemImage: "building") }
            NavigationView { ProfileView() }.tabItem { Label("Profile", systemImage: "person") }
        }
        .onAppear{
            UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance.init(idiom: .unspecified)
            CloudKitManager.shared.getUserRecord()
            viewModel.checkIfHasSeenOnboard()
        }
        .tabViewStyle(DefaultTabViewStyle())
        .tint(.brandPrimary)
        .sheet(isPresented: $viewModel.isShowingOnboardView) {
            OnboardView()
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
            .environmentObject(LocationManager())
    }
}
