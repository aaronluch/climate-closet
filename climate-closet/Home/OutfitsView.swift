import SwiftUI

struct OutfitListRow: View {
    var outfit: Outfit!
    var body: some View {
        HStack() {
            Text(outfit.name)
        }
    }
}

struct OutfitInfoView: View {
    var outfit: Outfit!
    
    var body: some View {
        VStack {
            ForEach(Clothing.Category.allCases, id: \.self) { category in
                let categorizedClothes = outfit.clothes.filter { $0.category == category }
                
                if !categorizedClothes.isEmpty {
                    Text(categoryTitle(category))
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                }
                
                ForEach(categorizedClothes) { clothing in
                    HStack {
                        // Conditionally load local or remote image
                        if clothing.isLocalImage, let imageName = clothing.imageUrl {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipped()
                        } else if let imageUrl = clothing.imageUrl, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                case .failure:
                                    Text("Failed to load image")
                                        .frame(width: 100, height: 100)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(8)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Text("Image not available")
                                .frame(width: 100, height: 100)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Text(clothing.name)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
    }
}



struct OutfitsView: View {
    @EnvironmentObject var outfitStore: OutfitStore
    
    var body: some View {
        List(outfitStore.allOutfits) { outfit in
            NavigationLink(destination: OutfitInfoView(outfit: outfit)) {
                OutfitListRow(outfit: outfit)
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
