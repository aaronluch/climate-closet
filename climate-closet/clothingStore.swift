import Foundation

class ClothesStore: ObservableObject {
    @Published var allClothes: [Clothing]
    
    init() {
        allClothes = []
        allClothes.append(Clothing(name: "Favorite T-shirt", owned: true, category: .top, minTemp: "15", maxTemp: "30", imageUrl: "tshirt.jpg"))
        allClothes.append(Clothing(name: "Grandpa's Jeans", owned: true, category: .bottom, minTemp: "10", maxTemp: "25", imageUrl: "jeans.jpg"))
    }
}
