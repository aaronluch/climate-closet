import Foundation
import SwiftUI

struct ClothingListRow: View {
    var clothing: Clothing!
    var body: some View {
        HStack() {
            Text(clothing.name)
        }
    }
}

struct ClothingInfoView: View {
    var clothing: Clothing!
    var body: some View {
        VStack {
            Text(clothing.name + " information")
        }
    }
}

struct ClothingListView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    
    var body: some View {
        List {
            ForEach(Clothing.Category.allCases, id: \.self) { category in
                Section(header: Text(categoryTitle(category))
                    .font(.headline)
                    .padding(.top)
                ) {
                    ForEach(clothesStore.allClothes.filter { $0.category == category }) { clothing in
                        NavigationLink(destination: ClothingInfoView(clothing: clothing)) {
                            ClothingListRow(clothing: clothing)
                        }
                    }
                }
            }
        }
        .navigationTitle("Wardrobe")
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


