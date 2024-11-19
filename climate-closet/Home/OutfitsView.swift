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

// extract images from clothing for outfit to access
struct OutfitClothingImageView: View {
    @ObservedObject var clothing: Clothing

    var body: some View {
        HStack {
            if clothing.isLocalImage {
                if let imageName = clothing.imageUrl {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipped()
                } else {
                    Text("Image not available")
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
            } else if let decodedImage = clothing.image {
                Image(uiImage: decodedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                let imgUrl: String? = clothing.imageUrl
                if let unw = imgUrl {
                    Text(unw)
                }
                Text("Image not available [here]")
                    .frame(width: 100, height: 100)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            Spacer()
            Text(clothing.name)
                .foregroundColor(.primary)
        }
    }
}

struct OutfitInfoView: View {
    @ObservedObject var outfit: Outfit

    var body: some View {
        VStack {
            ForEach(Clothing.Category.allCases, id: \.self) { category in
                let categorizedClothes = outfit.clothes.filter { $0.category == category }

                ForEach(categorizedClothes) { clothing in
                    OutfitClothingImageView(clothing: clothing)
                        .padding(.horizontal, 25)
                }
            }
        }
        .padding()
    }
}


struct OutfitsView: View {
    @EnvironmentObject var outfitStore: OutfitStore
    
    var body: some View {
        VStack {
            if outfitStore.allOutfits.isEmpty {
                Text("Loading...")
            } else {
                List(outfitStore.allOutfits) { outfit in
                    NavigationLink(destination: OutfitInfoView(outfit: outfit)) {
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
