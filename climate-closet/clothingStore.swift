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
        allClothes.append(Clothing(name: "Target T-shirt", owned: true, category: .top, minTemp: "55", maxTemp: "95", imageUrl: Image("target-tshirt")))
        allClothes.append(Clothing(name: "Generic White T-shirt", owned: true, category: .top, minTemp: "65", maxTemp: "80", imageUrl: Image("white-tshirt")))
        allClothes.append(Clothing(name: "Awesome T-shirt", owned: true, category: .top, minTemp: "35", maxTemp: "70", imageUrl: Image("awesome-tshirt")))
        
        // pants / bottoms
        allClothes.append(Clothing(name: "Grandpa's Old Jeans", owned: true, category: .bottom, minTemp: "40", maxTemp: "80", imageUrl: Image("old-jeans")))
        allClothes.append(Clothing(name: "Tech Pants", owned: false, category: .bottom, minTemp: "30", maxTemp: "75", imageUrl: Image("tech-pants")))
        
        // outerwear
        allClothes.append(Clothing(name: "Carhartt Jacket", owned: true, category: .outerwear, minTemp: "10", maxTemp: "55", imageUrl: Image("carhartt-jacket")))
        
        // accessories
        allClothes.append(Clothing(name: "Generic Silver Rings", owned: true, category: .accessory, minTemp: "0", maxTemp: "100", imageUrl: Image("silver-rings")))
        
        // shoes
        allClothes.append(Clothing(name: "Nike 77 Blazers", owned: true, category: .footwear, minTemp: "0", maxTemp: "100", imageUrl: Image("blazer-shoes")))
        
        // other
        allClothes.append(Clothing(name: "Funny Hat", owned: false, category: .other, minTemp: "0", maxTemp: "100", imageUrl: Image("funny-hat")))
    }
}
