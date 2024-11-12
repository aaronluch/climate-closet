import Foundation
import SwiftUI

class OutfitStore: ObservableObject {
    @Published var allOutfits: [Outfit]
    @ObservedObject var userSession = UserSession.shared
    
    func addOutfit(outfit: Outfit) {
        allOutfits.append(outfit)
    }
    
    init() {
        allOutfits = []
        let userID = userSession.userID ?? "na" // fallback on na
        
        // initialization of Clothing instances
        let shirt = Clothing(userID: userID, name: "Target T-shirt", owned: true, category: .top, minTemp: "55", maxTemp: "95", imageUrl: "target-tshirt", isLocalImage: true)
        let pants = Clothing(userID: userID, name: "Grandpa's Old Jeans", owned: true, category: .bottom, minTemp: "40", maxTemp: "80", imageUrl: "old-jeans", isLocalImage: true)
        
        let outfit1 = Outfit(userID: userID, name: "Sick fit", clothes: [])
        
        // adding clothing items to the outfit
        outfit1.addClothing(clothing: shirt)
        outfit1.addClothing(clothing: pants)
        
        // adding outfit to the store
        addOutfit(outfit: outfit1)
    }
}
