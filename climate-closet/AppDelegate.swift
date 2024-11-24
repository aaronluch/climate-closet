//
//  AppDelegate.swift
//  climate-closet
//
//  Created by Aaron Luciano on 11/7/24.
//

import Foundation
import SwiftUI
import FirebaseCore

// Manages app-wide configuration and setup, including initializing Firebase and customizing global UI elements
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        print("Firebase connected")
        
        // change nav title on all files
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .medium),
            .foregroundColor: UIColor.black
        ]
        
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = titleAttributes
        
        return true
    }
}
