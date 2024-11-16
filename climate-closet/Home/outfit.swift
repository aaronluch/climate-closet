import SwiftUI

class Outfit: Identifiable {
    var userID: String
    var itemID: String
    var name: String
    var clothes: [Clothing] = []
    
    init(userID: String = "", itemID: String, name: String = "", clothes: [Clothing] = []) {
        self.userID = userID
        self.itemID = itemID
        self.name = name
        self.clothes = clothes
    }
    
    func addClothing(_ clothing: Clothing) {
        if !clothes.contains(where: { $0.itemID == clothing.itemID }) {
            clothes.append(clothing)
        }
    }
    
    func removeClothing(_ clothing: Clothing) {
        clothes.removeAll { $0.itemID == clothing.itemID }
    }
    
    func listClothing() -> [Clothing] {
        return clothes
    }
}
