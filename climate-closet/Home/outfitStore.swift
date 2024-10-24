import Foundation
import SwiftUI

class OutfitStore: ObservableObject {
    @Published var allOutfits: [Outfit]
    
    func addOutfit(outfit: Outfit) {
        allOutfits.append(outfit)
    }
    
    init() {
        allOutfits = []
        let shirt = Clothing(name: "Target T-shirt", owned: true, category: .top, minTemp: "55", maxTemp: "95", imageUrl: Image("target-tshirt"))
        let pants = Clothing(name: "Grandpa's Old Jeans", owned: true, category: .bottom, minTemp: "40", maxTemp: "80", imageUrl: Image("old-jeans"))
        let outfit1 = Outfit(name: "Sick fit", clothes: [])
        outfit1.addClothing(clothing: shirt)
        outfit1.addClothing(clothing: pants)
    }
}
