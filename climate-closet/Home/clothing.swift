import SwiftUI

class Clothing: Identifiable, ObservableObject {
    var userID: String
    var name: String
    var owned: Bool
    var category: Category
    var minTemp: String
    var maxTemp: String
    var imageUrl: String? = nil // store image name for local images or url for remote images
    var isLocalImage: Bool = true // default to true for local images
    @Published var image: UIImage? // temp storage for image before upload
    

    enum Category: String, CaseIterable, Identifiable {
        case top, bottom, outerwear, accessory, footwear, other
        var id: String { rawValue }
    }
    
    init(userID: String = "", name: String = "", owned: Bool = true, category: Category = .other, minTemp: String = "", maxTemp: String = "", imageUrl: String? = nil, isLocalImage: Bool = true) {
        self.userID = userID
        self.name = name
        self.owned = owned
        self.category = category
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.imageUrl = imageUrl
        self.isLocalImage = isLocalImage
        self.image = image
    }
}
