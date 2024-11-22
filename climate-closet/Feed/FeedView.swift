import SwiftUI

struct FeedView: View {
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var showOutfitSelector = false // toggle if adding outfit
    @State private var selectedOutfitID: String? // track selected outfit ID for navigation

    var body: some View {
        NavigationStack {
            VStack {
                if outfitStore.feedOutfits.isEmpty {
                    Text("No outfits in the feed yet.")
                        .font(.headline)
                        .padding()
                } else {
                    List(outfitStore.feedOutfits, id: \.itemID) { outfit in
                        Button(action: {
                            selectedOutfitID = outfit.itemID
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
                        .background(
                            NavigationLink(value: outfit.itemID) {
                                EmptyView()
                            }
                        )
                    }
                }
            }
            .navigationTitle("Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showOutfitSelector.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showOutfitSelector) {
                OutfitSelectorView { selectedOutfit in
                    outfitStore.addToFeed(outfit: selectedOutfit)
                }
            }
            .navigationDestination(for: String.self) { outfitID in
                if let outfit = outfitStore.feedOutfits.first(where: { $0.itemID == outfitID }) {
                    OutfitDetailView(outfit: outfit)
                } else {
                    Text("Outfit not found.")
                }
            }
        }
    }
}
