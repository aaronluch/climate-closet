import Foundation
import SwiftUI

struct ClothingListRow: View {
    var clothing: Clothing!
    var body: some View {
        HStack() {
            clothing.imageUrl
                .resizable()
                .aspectRatio(1/1, contentMode: .fit)
                .frame(width: 30)
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
            VStack(alignment: .leading) {
                ForEach(Clothing.Category.allCases, id: \.self) { category in
                    Section(header: Text(categoryTitle(category))
                        .font(.headline)
                        .padding(.top)
                    ) {
                        let clothesForCategory = clothesStore.allClothes.filter { $0.category == category }
                        let rows = clothesForCategory.chunked(into: 3)
                        
                        ForEach(rows, id: \.self) { row in
                            HStack {
                                ForEach(row, id: \.id) { clothing in
                                    NavigationLink(destination: ClothingInfoView(clothing: clothing)) {
                                        ClothingListRow(clothing: clothing)
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }
                            Spacer()
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
