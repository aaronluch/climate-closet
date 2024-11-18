import SwiftUI
import Foundation

struct CreateOutfitView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var expandedCategories: [Clothing.Category: Bool] = [:]
    @State private var selectedClothes: [Clothing] = []

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
                        selectedClothing: .constant(nil), // Not used in selecting mode
                        mode: .selecting,
                        selectedClothes: $selectedClothes
                    )
                }

                // create new outfit button
                Button(action: {
                    outfitStore.createNewOutfit(
                        name: "need to add a text field for name of outfit",
                        clothes: selectedClothes
                    ) { success in
                        if success {
                            print("Outfit saved successfully!")
                            // clear after saving
                            selectedClothes.removeAll()
                        } else {
                            print("Failed to save outfit.")
                        }
                    }
                }) {
                    Text("Save Outfit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Create Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 10)
        }
        .onAppear {
            initializeExpandedCategories()
        }
    }

    private func initializeExpandedCategories() {
        for category in Clothing.Category.allCases {
            expandedCategories[category] = expandedCategories[category] ?? false
        }
    }
}
