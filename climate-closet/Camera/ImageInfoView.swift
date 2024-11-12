//
//  ImageInfoView.swift
//  climate-closet
//
//  Created by Aaron Luciano on 11/12/24.
//

import Foundation
import SwiftUI

struct ImageInfoView: View {
    @ObservedObject var clothing: Clothing
    var selectedImage: UIImage
    let onSave: () -> Void

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name", text: $clothing.name)
                
                Picker("Category", selection: $clothing.category) {
                    ForEach(Clothing.Category.allCases) { category in
                        Text(category.rawValue.capitalized).tag(category)
                    }
                }

                TextField("Min Temperature", text: $clothing.minTemp)
                    .keyboardType(.numberPad)

                TextField("Max Temperature", text: $clothing.maxTemp)
                    .keyboardType(.numberPad)
            }
            
            Button("Save and Upload") {
                // call helper function to set the image
                assignSelectedImage()
                onSave()
            }
            .padding()
        }
        .navigationTitle("Image Info")
    }
    
    private func assignSelectedImage() {
        clothing.image = selectedImage // update clothing image
    }
}
