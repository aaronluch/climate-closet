import Foundation
import SwiftUI

class ClothesStore: ObservableObject {
    @Published var allClothes: [Clothing]
    
    init() {
        allClothes = []
        
        // NOTE!!! This is to store all clothing information which will be loaded
        // in from firebase. At the moment, we're manually inputting it for
        // testing / preliminary purposes.
        
        // shirts / tops
        allClothes.append(Clothing(name: "Target T-shirt", owned: true, category: .top, minTemp: "55", maxTemp: "95", imageUrl: "target-tshirt", isLocalImage: true))
        allClothes.append(Clothing(name: "Generic White T-shirt", owned: true, category: .top, minTemp: "65", maxTemp: "80", imageUrl:"white-tshirt", isLocalImage: true))
        allClothes.append(Clothing(name: "Awesome T-shirt", owned: true, category: .top, minTemp: "35", maxTemp: "70", imageUrl: "awesome-tshirt", isLocalImage: true))
        
        // pants / bottoms
        allClothes.append(Clothing(name: "Grandpa's Old Jeans", owned: true, category: .bottom, minTemp: "40", maxTemp: "80", imageUrl: "old-jeans", isLocalImage: true))
        allClothes.append(Clothing(name: "Tech Pants", owned: false, category: .bottom, minTemp: "30", maxTemp: "75", imageUrl: "tech-pants", isLocalImage: true))
        
        // outerwear
        allClothes.append(Clothing(name: "Carhartt Jacket", owned: true, category: .outerwear, minTemp: "10", maxTemp: "55", imageUrl: "carhartt-jacket", isLocalImage: true))
        
        // accessories
        allClothes.append(Clothing(name: "Generic Silver Rings", owned: true, category: .accessory, minTemp: "0", maxTemp: "100", imageUrl: "silver-rings", isLocalImage: true))
        
        // shoes
        allClothes.append(Clothing(name: "Nike 77 Blazers", owned: true, category: .footwear, minTemp: "0", maxTemp: "100", imageUrl: "blazer-shoes", isLocalImage: true))
        
        // other
        allClothes.append(Clothing(name: "Funny Hat", owned: false, category: .other, minTemp: "0", maxTemp: "100", imageUrl: "funny-hat", isLocalImage: true))
    }
}
