import Foundation
import SwiftUI

// Displays the user's wardrobe categorized by clothing types
// Allows for expandable and interactive browsing of items
struct WardrobeView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    @State private var expandedCategories: [Clothing.Category: Bool] = [:]
    @State private var selectedClothing: Clothing?

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
                        ),
                        selectedClothing: $selectedClothing,
                        mode: .browsing,
                        selectedClothes: .constant([]) // not used while browsing wardrobe
                    )
                }
            }
            .navigationTitle("Wardrobe")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 10)
        }
        .onAppear {
            initializeExpandedCategories()
        }
    }

    // Initializes the expansion states for all clothing categories to false by default
    private func initializeExpandedCategories() {
        for category in Clothing.Category.allCases {
            expandedCategories[category] = expandedCategories[category] ?? false
        }
    }
}
