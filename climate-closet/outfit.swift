import SwiftUI

class Outfit: Identifiable {
    var name: String
    var clothes: [Clothing]
    
    
    init(name: String = "", clothes: [Clothing]) {
        self.name = name
        self.clothes = clothes
        
    }
}
