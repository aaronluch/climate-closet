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
    @State private var expandedCategories: [Clothing.Category: Bool] = [:]  // track expanded/collapsed state for each category
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Clothing.Category.allCases, id: \.self) { category in
                    VStack {
                        // header for each collapsible section
                        // toggle Button for collapsing/expanding
                        Button(action: {
                            withAnimation{
                                // sets the expanded/collapsed state for the category
                                expandedCategories[category]?.toggle()
                            }
                        }) {
                            HStack {
                                Text(categoryTitle(category))
                                    .font(.title2)
                                    .fontWeight(expandedCategories[category] == true ? .bold : .regular)
                                    .padding(.top)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 25)
                                Spacer()
                                // chevron (arrow for open or closed)
                                Image(systemName: expandedCategories[category] == true ? "chevron.up" : "chevron.down")
                                    .fontWeight(expandedCategories[category] == true ? .bold : .regular)
                                    .padding(.trailing, 25)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // conditionally show the clothing items if the section is expanded
                        if expandedCategories[category] == true {
                            ForEach(clothesStore.allClothes.filter { $0.category == category }) { clothing in
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
            .navigationTitle("Wardrobe")
            .padding(.top, 10)
        }
        .onAppear {
            // initialize the expanded state for all categories as collapsed
            for category in Clothing.Category.allCases {
                if expandedCategories[category] == nil {
                    expandedCategories[category] = false
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
