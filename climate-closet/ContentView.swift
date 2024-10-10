//  ContentView.swift
//  climate-closet

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
            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera")
                }
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            }
        .padding()
    }
}

#Preview {
    ContentView()
}
