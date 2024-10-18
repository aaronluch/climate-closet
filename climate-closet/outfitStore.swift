import Foundation

class OutfitStore: ObservableObject {
    @Published var allOutfits: [Outfit]
    
    init() {
        allOutfits = []
    }
}
