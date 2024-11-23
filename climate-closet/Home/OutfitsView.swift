import SwiftUI

struct OutfitsView: View {
    @EnvironmentObject var outfitStore: OutfitStore
    
    var body: some View {
        
        VStack {
            let savedOutfits = outfitStore.getUnplannedOutfits()
            
            if savedOutfits.isEmpty {
                Text("No outfits found!")
                    .font(.headline)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(savedOutfits) { outfit in
                            NavigationLink(destination: OutfitDetailView(outfit: outfit)) {
                                OutfitListRow(outfit: outfit)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
            }
            Spacer() // Push the content to the top
        }
        .navigationTitle("Your Outfits")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// this is in a dumb spot but our file structure is really bad so im just leaving it...
struct OutfitListRow: View {
    let outfit: Outfit
    
    var body: some View {
        HStack {
            if let thumbnail = outfit.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                    Text("No Image")
                        .foregroundColor(.white)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
            Text(outfit.name)
                .font(.headline)
                .padding(.leading, 10)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .frame(height: 90)
        .cornerRadius(12)
    }
}
