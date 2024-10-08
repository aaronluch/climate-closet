import Foundation

class ClothesStore: ObservableObject {
    @Published var allClothes: [Clothing]
    
    init() {
        allClothes = []
        allClothes.append(Clothing())
}
}
