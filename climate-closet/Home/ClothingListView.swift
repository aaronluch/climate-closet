import Foundation
import SwiftUI

struct ClothingListRow: View {
    var clothing: Clothing
    
    var body: some View {
        HStack {
            if clothing.isLocalImage {
                // local hardcoded image
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
            } else {
                // remote image from Firebase using AsyncImage
                if let imageUrl = clothing.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Show a loading spinner
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
            }
            
            Spacer()
        }
        .padding()
    }
}

// Shows the information about each article of clothing when
// expanding each piece of clothing
struct ClothingInfoView: View {
    @ObservedObject var clothing: Clothing

    var body: some View {
        VStack {
            if clothing.isLocalImage {
                // render local hardcoded image
                if let imageName = clothing.imageUrl {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } else {
                    Text("Image not available")
                }
            } else {
                // render image from Firebase using AsyncImage for URL
                if let imageUrl = clothing.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // loading spinner
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        case .failure:
                            Text("Failed to load image")
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Text("Image not available")
                }
            }
            
            Text(clothing.name)
                .font(.headline)
                .padding(.top, 5)
            
            Text(clothing.category.rawValue.capitalized)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)))
        .shadow(radius: 5)
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
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 10)
        }
        .onAppear {
            for category in Clothing.Category.allCases {
                expandedCategories[category] = expandedCategories[category] ?? false
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
