import Foundation
import SwiftUI

struct OutfitSelectorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var outfitStore: OutfitStore
    let onOutfitSelected: (Outfit) -> Void
    @State private var unplannedOutfits: [Outfit] = [] // local to hold unplanned outfits
    
    var body: some View {
        NavigationView {
            VStack {
                if unplannedOutfits.isEmpty {
                    Text("No unplanned outfits available.")
                        .font(.headline)
                        .padding()
                } else {
                    List(unplannedOutfits, id: \.itemID) { outfit in
                        Button(action: {
                            onOutfitSelected(outfit)
                            presentationMode.wrappedValue.dismiss() // dismiss view
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
            .navigationTitle("Select an outfit to upload")
            .onAppear(perform: fetchUnplannedOutfits)
            .onReceive(outfitStore.$allOutfits) { _ in
                fetchUnplannedOutfits() // update list whenever a new outfit (isnt planned for weather) is added
            }
        }
    }

    private func fetchUnplannedOutfits() {
        unplannedOutfits = outfitStore.allOutfits.filter { !$0.isPlanned }
    }
}
