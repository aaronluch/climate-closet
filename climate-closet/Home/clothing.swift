import SwiftUI

class Clothing: Identifiable, ObservableObject {
    @Published var userID: String
    @Published var itemID: String
    @Published var name: String
    @Published var owned: Bool
    @Published var category: Category
    @Published var minTemp: String
    @Published var maxTemp: String
    @Published var imageUrl: String? = nil // store image name for local images or url for remote images
    @Published var isLocalImage: Bool = true // default to true for local images
    @Published var image: UIImage? // temp storage for image before upload
    

    enum Category: String, CaseIterable, Identifiable {
        case top, bottom, outerwear, accessory, footwear, other
        var id: String { rawValue }
    }
    
    init(userID: String, itemID: String, name: String = "", owned: Bool = true, category: Category = .other, minTemp: String = "", maxTemp: String = "", imageUrl: String? = nil, isLocalImage: Bool = true) {
        self.userID = userID
        self.itemID = itemID
        self.name = name
        self.owned = owned
        self.category = category
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.imageUrl = imageUrl
        self.isLocalImage = isLocalImage
        
        decodeImage()
    }
    
    func decodeImage() {
        if !isLocalImage, image == nil, let imageUrl = imageUrl, let imageData = Data(base64Encoded: imageUrl) {
            self.image = UIImage(data: imageData)
        }
    }
}

extension Clothing {
    static func == (lhs: Clothing, rhs: Clothing) -> Bool {
        return lhs.id == rhs.id
    }
}
