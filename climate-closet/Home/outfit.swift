import SwiftUI
// WIP
class Outfit: Identifiable {
    var userID: String
    var name: String
    var clothes: [Clothing]
    
    func addClothing(clothing: Clothing) {
        clothes.append(clothing)
    }
    
    init(userID: String = "", name: String = "", clothes: [Clothing]) {
        self.userID = userID
        self.name = name
        self.clothes = clothes
    }
}

