import Foundation
import SwiftUI

// For each list of clothing type
// Shows each image for that respective article
struct ClothingListRow: View {
    var clothing: Clothing!
    var body: some View {
        HStack() {
            clothing.imageUrl
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipped()
            Spacer()
        }
        .frame(width: 100, height: 100)
        .padding()
    }
}

// Shows the information about each article of clothing when
// expanding each piece of clothing
struct ClothingInfoView: View {
    var clothing: Clothing!
    var body: some View {
        VStack {
            List {
                // Clothing image
                VStack {
                    clothing.imageUrl
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 20)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
                .listRowSeparator(.hidden)  // Hide separator for the image
                
                // Clothing Name
                HStack {
                    Text("Name: ")
                    Spacer()
                    Text(clothing.name)
                }
                
                // Owned status
                HStack {
                    Text("Owned:")
                    Spacer()
                    Text(clothing.owned ? "Yes" : "No")
                }
                
                // Category
                HStack {
                    Text("Category:")
                    Spacer()
                    Text(categoryTitle(clothing.category))
                }
                
                // Temperature range
                HStack {
                    Text("Temperature Range:")
                    Spacer()
                    Text("\(clothing.minTemp)° to \(clothing.maxTemp)°")
                }
            }
            .listStyle(InsetGroupedListStyle())
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
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 25)
                    ) {
                        ForEach(clothesStore.allClothes.filter { $0.category == category }) { clothing in
                            NavigationLink(destination: ClothingInfoView(clothing: clothing)) {
                                ClothingListRow(clothing: clothing)
                                Text(clothing.name).foregroundColor(.primary)
                                Spacer()
                                Spacer()
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
