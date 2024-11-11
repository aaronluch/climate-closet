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
                
                if categorizedClothes.isEmpty == false {
                    Text(categoryTitle(category))
                        .font(.title2)
                        .fontWeight(.bold)
                    //.padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                }
                
                ForEach(categorizedClothes) { clothing in
                    HStack() {
                        clothing.imageUrl
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipped()
                        Spacer()
                        Text(clothing.name)
                    }
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
