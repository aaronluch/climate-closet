//
//  SettingsView.swift
//  climate-closet
//
//  Created by Aaron Luciano on 11/11/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        List {
            NavigationLink(destination: Text("Account Name Settings")) {
                Text("Account Name")
            }
            NavigationLink(destination: Text("Security Settings")) {
                Text("Security")
            }
            NavigationLink(destination: Text("Theme Settings")) {
                Text("Theme")
            }
            NavigationLink(destination: Text("Feed Settings")) {
                Text("Feed Settings")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
