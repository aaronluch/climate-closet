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
    @State private var expandedCategories: [Clothing.Category: Bool] = [:]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Clothing.Category.allCases, id: \.self) { category in
                    ExpandableClothingCategoryView(
                        category: category,
                        clothes: clothesStore.allClothes.filter { $0.category == category },
                        isExpanded: Binding(
                            get: { expandedCategories[category, default: false] },
                            set: { expandedCategories[category] = $0 }
                            )
                    )
                }

            }
            .navigationTitle("Wardrobe")
            .padding(.top, 10)
        }
        .onAppear {
            for category in Clothing.Category.allCases {
                expandedCategories[category] = expandedCategories[category] ?? false
            }
        }
    }
}

struct ExpandableClothingCategoryView: View {
    var category: Clothing.Category
    var clothes: [Clothing]
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(categoryTitle(category))
                        .font(.title2)
                        .fontWeight(isExpanded ? .bold : .regular)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 25)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .fontWeight(isExpanded ? .bold : .regular)
                        .padding(.trailing, 25)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                ForEach(clothes) { clothing in
                    NavigationLink(destination: ClothingInfoView(clothing: clothing)) {
                        HStack {
                            ClothingListRow(clothing: clothing)
                            Text(clothing.name)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}


// category title helper function
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
