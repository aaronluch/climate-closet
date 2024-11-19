import Foundation
import SwiftUI

struct ClothingListRow: View {
    var clothing: Clothing
    
    var body: some View {
        HStack {
            if clothing.isLocalImage {
                // if local hardcoded image
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
                // decode base64 image
                Image(uiImage: decodedImage)
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
        VStack() {
            // renders depending on if local or on firebase db
            if clothing.isLocalImage {
                // render local hardcoded image
                if let imageName = clothing.imageUrl {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                } else {
                    Text("Image not available")
                        .frame(width: 200, height: 200)
                        .background(Color.gray.opacity(0.3))
                }
            } else if let decodedImage = clothing.image {
                // decoded base64 image
                Image(uiImage: decodedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
            } else {
                Text("Image not available")
                    .frame(width: 200, height: 200)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            
            // clothing details
            VStack(alignment: .leading, spacing: 5) {
                Text(clothing.name)
                    .font(.headline)
                Text("Category: \(clothing.category.rawValue.capitalized)")
                    .font(.subheadline)
                Text("Owned: \(clothing.owned ? "Yes" : "No")")
                    .font(.subheadline)
                Text("Temperature Range: \(clothing.minTemp)° - \(clothing.maxTemp)°")
                    .font(.subheadline)
            }
            .padding(.top, 5)
        }
        .padding()
        //.border(Color.red, width: 4) - just to view bounds
    }
}

struct ClothingRowView: View {
    var clothing: Clothing
    var isSelected: Bool
    var onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack {
                ClothingListRow(clothing: clothing)
                Text(clothing.name)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.08))
            .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

enum ExpandableClothingCategoryMode {
    case browsing // for WardrobeView
    case selecting // for CreateOutfitView
}

struct ExpandableClothingCategoryView: View {
    var category: Clothing.Category
    var clothes: [Clothing]
    @Binding var isExpanded: Bool
    @Binding var selectedClothing: Clothing?
    var mode: ExpandableClothingCategoryMode
    @Binding var selectedClothes: [Clothing] // for creating outfit, array of clothes

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
                        .fontWeight(.bold)
                        .padding(.trailing, 25)
                }
            }
            .buttonStyle(PlainButtonStyle())

            // render clothes if expanded
            if isExpanded {
                if clothes.isEmpty {
                    Text("Nothing here yet...")
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(clothes, id: \.id) { clothing in
                        if mode == .browsing {
                            NavigationLink(destination: ClothingInfoView(clothing: clothing)) {
                                clothingRowContent(for: clothing)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        } else if mode == .selecting {
                            Button(action: {
                                toggleSelection(for: clothing)
                            }) {
                                clothingRowContent(for: clothing)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
        }
    }

    // helper function for clothing row content
    private func clothingRowContent(for clothing: Clothing) -> some View {
        HStack {
            ClothingListRow(clothing: clothing)
            Text(clothing.name)
                .foregroundColor(.primary)
            Spacer()
            if mode == .selecting && selectedClothes.contains(where: { $0.id == clothing.id }) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(mode == .selecting && selectedClothes.contains(where: { $0.id == clothing.id }) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.08))
        .cornerRadius(10)
    }

    private func toggleSelection(for clothing: Clothing) {
        if let index = selectedClothes.firstIndex(where: { $0.id == clothing.id }) {
            selectedClothes.remove(at: index)
        } else {
            selectedClothes.append(clothing)
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
}
