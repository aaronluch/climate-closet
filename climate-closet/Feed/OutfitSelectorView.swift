import Foundation
import SwiftUI

struct OutfitSelectorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var outfitStore: OutfitStore
    let onOutfitSelected: (Outfit) -> Void // Callback for the selected outfit

    var body: some View {
        NavigationView {
            VStack {
                if outfitStore.allOutfits.isEmpty {
                    Text("No outfits available.")
                        .font(.headline)
                        .padding()
                } else {
                    List(outfitStore.allOutfits, id: \.itemID) { outfit in
                        Button(action: {
                            onOutfitSelected(outfit)
                            presentationMode.wrappedValue.dismiss() // Dismiss the view
                        }) {
                            HStack {
                                if let thumbnail = outfit.thumbnail {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                }
                                Text(outfit.name)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select an Outfit")
        }
    }
}
