import Foundation
import SwiftUI

class ClothesStore: ObservableObject {
    @Published var allClothes: [Clothing]
    
    init() {
        allClothes = []
        
        allClothes.append(Clothing(name: "Favorite T-shirt", owned: true, category: .top, minTemp: "15", maxTemp: "30", imageUrl: Image("tshirt")))
        allClothes.append(Clothing(name: "Favorite T-shirt", owned: true, category: .top, minTemp: "15", maxTemp: "30", imageUrl: Image("tshirt")))
        allClothes.append(Clothing(name: "Favorite T-shirt", owned: true, category: .top, minTemp: "15", maxTemp: "30", imageUrl: Image("tshirt")))
        allClothes.append(Clothing(name: "Grandpa's Jeans", owned: true, category: .bottom, minTemp: "10", maxTemp: "25", imageUrl: Image("jeans")))
    }
}
