import SwiftUI
// WIP
class Outfit: Identifiable {
    var userID: String
    var itemID: String
    var clothingIDs: [String]
    var name: String
    var clothes: [Clothing] = []
    
    
    //func addClothing(clothing: Clothing) {
       // clothes.append(clothing)
  //  }
    
    init(userID: String = "", itemID: String, clothingIDs: [String], name: String = "") {
        self.userID = userID
        self.itemID = itemID
        self.clothingIDs = clothingIDs
        self.name = name
        
    }
}

