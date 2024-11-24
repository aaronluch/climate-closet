//
//  climate_closetApp.swift
//  climate-closet
//
//  Created by Aaron Luciano on 10/8/24.
//

import SwiftUI

// Main entry point of ClimateCloset
@main
struct climate_closetApp: App {
    // connect app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
