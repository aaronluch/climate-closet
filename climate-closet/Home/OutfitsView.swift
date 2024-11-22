import SwiftUI

struct OutfitListRow: View {
    var outfit: Outfit
    
    var body: some View {
        VStack() {
            HStack() {
                // thumbnail if avail
                if let thumbnailImage = outfit.thumbnail {
                    Image(uiImage: thumbnailImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.bottom, 10)
                }
                // outfit name
                Text(outfit.name)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct OutfitsView: View {
    @EnvironmentObject var outfitStore: OutfitStore
    
    var body: some View {
        VStack {
            let savedOutfits = outfitStore.getUnplannedOutfits()
            
            if savedOutfits.isEmpty {
                Text("No outfits found!")
            } else {
                List(savedOutfits) { outfit in
                    NavigationLink(destination: OutfitDetailView(outfit: outfit)) {
                        OutfitListRow(outfit: outfit)
                    }
                }
            }
        }
        .navigationTitle("Outfits")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private func categoryTitle(_ category: Clothing.Category) -> String {
    switch category {
    case .top: return "Tops"
    case .bottom: return "Bottoms"
    case .outerwear: return "Outerwear"
    case .accessory: return "Accessories"
    case .footwear: return "Footwear"
    case .other: return "Other"
    }
}
