import SwiftUI

struct FeedView: View {
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var showOutfitSelector = false
    @State private var selectedOutfitID: String?

    var body: some View {
        NavigationStack {
            VStack {
                if outfitStore.feedOutfits.isEmpty {
                    Text("No outfits in the feed yet.")
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(outfitStore.feedOutfits, id: \.itemID) { outfit in
                                NavigationLink(value: outfit.itemID) {
                                    OutfitListRow(outfit: outfit)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
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
