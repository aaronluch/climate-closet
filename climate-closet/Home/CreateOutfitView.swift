import Foundation
import SwiftUI

struct CreateOutfitView: View {
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
                if expandedCategories[category] == nil {
                    expandedCategories[category] = false
                }
            }
        }
    }
}
