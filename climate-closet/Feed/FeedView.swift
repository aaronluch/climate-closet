import SwiftUI
import Firebase

struct FeedView: View {
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var showOutfitSelector = false // controls the display of the outfit selector view
    
    var body: some View {
        NavigationView {
            VStack {
                // list all outfits in feed collection
                if outfitStore.feedOutfits.isEmpty {
                    Text("No outfits in the feed yet.")
                        .font(.headline)
                        .padding()
                } else {
                    List(outfitStore.feedOutfits, id: \.itemID) { outfit in
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
            
            // opens outfit selector view
            .navigationTitle("Feed")
            .toolbar {
                // Add the "+" button to the top-right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showOutfitSelector.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.title2) // Adjust the size of the button
                    }
                }
            }
            .sheet(isPresented: $showOutfitSelector) {
                OutfitSelectorView { selectedOutfit in
                    outfitStore.addToFeed(outfit: selectedOutfit) // add selected outfit to feed
                }
            }
        }
        .onAppear {
            outfitStore.listenForFeedUpdates() // listen for updates on feed
        }
    }
}

