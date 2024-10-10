import Foundation
import SwiftUI

struct ClothingListRow: View {
    var clothing: Clothing!
    var body: some View {
        HStack() {
            Text(clothing.name)
        }
    }
}

struct ClothingInfoView: View {
    var clothing: Clothing!
    var body: some View {
        VStack {
            Text(clothing.name + " information")
        }
    }
}

struct ClothingListView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    
    var body: some View {
        VStack() {
            NavigationStack {
                List(clothesStore.allClothes.indices) { index in
                    NavigationLink(
                        destination: ClothingInfoView(clothing: clothesStore.allClothes[index])) {
                            ClothingListRow(clothing: clothesStore.allClothes[index])
                        }
                }
            }
        }
    }
}


