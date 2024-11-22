//  ContentView.swift
//  climate-closet
//  Aaron Luciano, Aman Chase, Amy Tully, Bella Cordero

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.bullet")
                }
                .environmentObject(OutfitStore())
            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
                .environmentObject(OutfitStore())
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
