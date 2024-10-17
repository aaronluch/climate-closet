import Foundation
import SwiftUI

struct ClothingListRow: View {
    var clothing: Clothing!
    var body: some View {
        HStack() {
            clothing.imageUrl
                .resizable()
                .aspectRatio(1/1, contentMode: .fit)
                .frame(width: 30, height: 30)
                .clipped()
            Spacer()
        }
        .padding()
    }
}

struct ClothingInfoView: View {
    var clothing: Clothing!
    var body: some View {
        VStack {
            Text(clothing.name + " information")
            Text(clothing.name)
        }
    }
}

struct ClothingListView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Clothing.Category.allCases, id: \.self) { category in
                    Section(header: Text(categoryTitle(category))
                        .font(.headline)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 15)
                    ) {
                        ForEach(clothesStore.allClothes.filter { $0.category == category }) { clothing in
                            NavigationLink(destination: ClothingInfoView(clothing: clothing)) {
                                ClothingListRow(clothing: clothing)
                                Text(clothing.name).foregroundColor(.black)
                            }.padding()
                        }
                    }
                }
            }
            .navigationTitle("Wardrobe")
            .padding(.top, 10)
        }
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
