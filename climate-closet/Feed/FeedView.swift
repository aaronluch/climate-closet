import SwiftUI

// Displays the feed of outfits in a scrollable list
// Handles nav to the details of a selected outfit and can add new outfits.
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
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            // Toolbar where you can add outfits from the plus sign button from your own (current user) outfits list
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("CCLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text("Feed")
                            .font(.system(size: 32))
                            .fontWeight(.regular)
                    }
                }
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
            // resolves nav links, will error if cant find that outfit
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
