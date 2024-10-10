import SwiftUI

class Clothing: Identifiable {
    var name: String
    var owned: Bool
    var category: Category
    var minTemp: String
    var maxTemp: String
    var imageUrl: String
    
    enum Category {
        case top, bottom, outerwear, accessory, footwear, other
    }
    
    init(name: String = "", owned: Bool = true, category: Category = .other, minTemp: String = "", 
    maxTemp: String = "", imageUrl: String = "") {
        self.name = name
        self.owned = owned
        self.category = category
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.imageUrl = imageUrl
    }
}
