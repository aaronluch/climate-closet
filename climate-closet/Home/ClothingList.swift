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
    @EnvironmentObject var clothesStore: ClothesStore
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingDialog = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Image section
                VStack {
                    if clothing.isLocalImage {
                        if let imageName = clothing.imageUrl {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(maxWidth: geometry.size.width - 20, maxHeight: .infinity)
                        } else {
                            Text("Image not available")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        }
                    } else if let decodedImage = clothing.image {
                        Image(uiImage: decodedImage)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(maxWidth: geometry.size.width - 20, maxHeight: .infinity)
                    } else {
                        Text("Image not available")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
                .frame(height: geometry.size.height / 2)

                // details section
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(clothing.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                    }

                    HStack {
                        Text("Details:")
                            .bold()
                            .font(.title3)
                    }

                    // category
                    HStack {
                        Text("Category:")
                            .bold()
                            .font(.headline)
                        Spacer()
                        Text(clothing.category.rawValue.capitalized)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Image(systemName: systemImageName(for: clothing.category))
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }

                    // owned
                    HStack {
                        Text("Owned:")
                            .bold()
                            .font(.headline)
                        Spacer()
                        Text(clothing.owned ? "Yes" : "No")
                            .foregroundColor(clothing.owned ? .green : .red)
                            .font(.subheadline)
                    }

                    // temperature Range
                    HStack {
                        Text("Temperature Range:")
                            .bold()
                            .font(.headline)
                        Spacer()
                        Text("\(clothing.minTemp)° - \(clothing.maxTemp)°")
                            .font(.subheadline)
                    }
                    
                    // Button to delete clothing item
                    Button(action: {
                        isShowingDialog = true
                    }) {
                        Text("Delete")
                    }
                    .confirmationDialog("Are you sure you want to delete this clothing item?", isPresented: $isShowingDialog, titleVisibility: .visible) {
                        Button("Delete", role: .destructive) {
                            clothesStore.deleteClothing(clothing) { _ in }
                            presentationMode.wrappedValue.dismiss()
                        }
                        Button("Cancel", role: .cancel) {
                            isShowingDialog = false
                        }
                    }
                }
                .padding()
                .frame(height: geometry.size.height / 2, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
}

// helper function to get relative image for clothing cateogry
private func systemImageName(for category: Clothing.Category) -> String {
    switch category {
    case .top:
        return "tshirt.fill" // symbol for tops
    case .bottom:
        return "figure.stand" // bottoms
    case .outerwear:
        return "cloud.rain.fill" // outerwear (wanted to use jacket but not up to date with simulator
    case .accessory:
        return "sparkles" // accessories
    case .footwear:
        return "shoeprints.fill" // shoes / footwear
    case .other:
        return "questionmark" // other
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
            if let thumbnail = clothing.image {
                Image(uiImage: thumbnail)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(8)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 70, height: 70)
                        .cornerRadius(8)
                    Text("No Image")
                        .foregroundColor(.white)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
            Text(clothing.name)
                .font(.headline)
                .padding(.leading, 10)
                .foregroundColor(.black)
            Spacer()
            if mode == .browsing {
                Image(systemName: "chevron.right")
            } else if mode == .selecting {
                if selectedClothes.contains(where: { $0.id == clothing.id }) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
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
