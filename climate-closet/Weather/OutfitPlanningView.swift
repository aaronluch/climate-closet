//
//  OutfitPlanningView.swift
//  climate-closet
//
//  Created by Isabella Cordero on 10/29/24.
//


import SwiftUI

struct OutfitPlanningView: View {
    @State private var selectedShirt: String = ""
    @State private var selectedPants: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Plan Tomorrow's Outfit")
                .font(.largeTitle)
                .padding()

            TextField("Shirt", text: $selectedShirt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Pants", text: $selectedPants)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Add action for saving or processing outfit selection
            }) {
                Text("Save Outfit")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 2)
                    .cornerRadius(8)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Outfit Planning")
    }
}

struct OutfitPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitPlanningView()
    }
}
