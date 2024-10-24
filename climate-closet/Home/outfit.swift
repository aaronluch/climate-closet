import SwiftUI
// WIP
class Outfit: Identifiable {
    var name: String
    var clothes: [Clothing]
    
    func addClothing(clothing: Clothing) {
        clothes.append(clothing)
    }
    
    init(name: String = "", clothes: [Clothing]) {
        self.name = name
        self.clothes = clothes
        
    }
}

