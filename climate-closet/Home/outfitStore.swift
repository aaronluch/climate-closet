import Foundation
import SwiftUI

class OutfitStore: ObservableObject {
    @Published var allOutfits: [Outfit]
    
    func addOutfit(outfit: Outfit) {
        allOutfits.append(outfit)
    }
    
    init() {
        allOutfits = []
        
        // initialization of Clothing instances
        let shirt = Clothing(name: "Target T-shirt", owned: true, category: .top, minTemp: "55", maxTemp: "95", imageUrl: "target-tshirt", isLocalImage: true)
        let pants = Clothing(name: "Grandpa's Old Jeans", owned: true, category: .bottom, minTemp: "40", maxTemp: "80", imageUrl: "old-jeans", isLocalImage: true)
        
        let outfit1 = Outfit(name: "Sick fit", clothes: [])
        
        // adding clothing items to the outfit
        outfit1.addClothing(clothing: shirt)
        outfit1.addClothing(clothing: pants)
        
        // adding outfit to the store
        addOutfit(outfit: outfit1)
    }
}
