import SwiftUI

// Represents an outfit, consisting of user ID, name, associated clothing items, and whether it is planned
class Outfit: Identifiable, ObservableObject {
    var userID: String
    var itemID: String
    var name: String
    @Published var clothes: [Clothing] = []
    @Published var isPlanned: Bool
    var thumbnail: UIImage?
    
    init(userID: String = "", itemID: String, name: String = "", clothes: [Clothing] = [], isPlanned: Bool = false, thumbnail: UIImage? = nil) {
        self.userID = userID
        self.itemID = itemID
        self.name = name
        self.clothes = clothes
        self.isPlanned = isPlanned
        self.thumbnail = thumbnail
    }
    
    // Add a new clothing item if it doesn't already exist
    func addClothing(_ clothing: Clothing) {
        if !clothes.contains(where: { $0.itemID == clothing.itemID }) {
            clothes.append(clothing)
        }
    }
    
    // Remove a specific clothing item
    func removeClothing(_ clothing: Clothing) {
        clothes.removeAll { $0.itemID == clothing.itemID }
    }
    
    // Lists the clothing items (used for debug)
    func listClothing() -> [Clothing] {
        return clothes
    }
}
