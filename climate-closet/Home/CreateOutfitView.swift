import Foundation
import SwiftUI

struct CreateOutfitView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    @EnvironmentObject var outfitStore: OutfitStore
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
                if expandedCategories[category] == nil {
                    expandedCategories[category] = false
                }
            }
        }
        
        // example of MANUALLY adding in an outfit to firebase,
        // we will need to give this as a selection of clothing objects though
        Button(action: {
            outfitStore.createNewOutfit(
                name: "create test outfit",
                clothes: [
                    Clothing (
                        userID: outfitStore.userSession.userID ?? "",
                        itemID: UUID().uuidString,
                        name: "Test Jacket",
                        category: .outerwear,
                        minTemp: "30",
                        maxTemp: "50"
                    ),
                    Clothing (
                        userID: outfitStore.userSession.userID ?? "",
                        itemID: UUID().uuidString,
                        name: "Test Pants",
                        category: .bottom,
                        minTemp: "30",
                        maxTemp: "50"
                    )
                ]
            ) { success in
                if success {
                    print("saved successfully")
                } else {
                    print("failed to save tester fit")
                }
            }
        }) {
            Text("Save test outfit")
        }
    }
}
