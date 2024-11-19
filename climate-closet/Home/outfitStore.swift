import Foundation
import SwiftUI
import FirebaseFirestore

class OutfitStore: ObservableObject {
    @ObservedObject var userSession = UserSession.shared
    @EnvironmentObject var outfitStore: OutfitStore
    @Published var allOutfits: [Outfit] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        listenForOutfitUpdates()
    }
    
    deinit {
        listener?.remove()
    }
    
    func listenForOutfitUpdates() {
        guard let userID = userSession.userID else {
            print("User is not logged in.")
            return
        }
        
        listener = db.collection("outfits")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error listening for outfit updates: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No outfits found for this user.")
                    return
                }
                
                self.allOutfits = documents.compactMap { doc in
                    let data = doc.data()
                    return self.parseOutfitData(data, documentID: doc.documentID)
                }
            }
    }
    
    private func parseOutfitData(_ data: [String: Any], documentID: String) -> Outfit? {
        guard
            let userID = data["userID"] as? String,
            let name = data["name"] as? String,
            let clothesData = data["clothes"] as? [[String: Any]]
        else {
            print("Error parsing outfit data.")
            return nil
        }
        
        let itemID = data["itemID"] as? String ?? ""
        
        let clothes = clothesData.compactMap { clothingDict -> Clothing? in
            guard
                let itemID = clothingDict["itemID"] as? String,
                let name = clothingDict["name"] as? String,
                let categoryRaw = clothingDict["category"] as? String,
                let category = Clothing.Category(rawValue: categoryRaw),
                let minTemp = clothingDict["minTemp"] as? String,
                let maxTemp = clothingDict["maxTemp"] as? String
            else {
                print("Error parsing clothing data in outfit.")
                return nil
            }
            
            return Clothing(
                userID: userID,
                itemID: itemID,
                name: name,
                category: category,
                minTemp: minTemp,
                maxTemp: maxTemp,
                imageUrl: clothingDict["imageUrl"] as? String,
                isLocalImage: clothingDict["isLocalImage"] as? Bool ?? false
            )
        }
        
        let outfit = Outfit(userID: userID, itemID: itemID, name: name, clothes: clothes)
                
        // decode the base64 thumbnail image
        if let thumbnailBase64 = data["thumbnail"] as? String, let imageData = Data(base64Encoded: thumbnailBase64) {
            outfit.thumbnail = UIImage(data: imageData)
        }

        return outfit
    }
}

extension OutfitStore {
    func saveOutfit(_ outfit: Outfit, completion: @escaping (Bool) -> Void) {
        guard let userID = userSession.userID else {
            print("User is not logged in.")
            completion(false)
            return
        }
        
        var data: [String: Any] = [
            "userID": userID,
            "itemID": outfit.itemID,
            "name": outfit.name,
            "clothes": outfit.clothes.map { clothing in
                var clothingData: [String: Any] = [
                    "itemID": clothing.itemID,
                    "name": clothing.name,
                    "category": clothing.category.rawValue,
                    "minTemp": clothing.minTemp,
                    "maxTemp": clothing.maxTemp,
                    "isLocalImage": clothing.isLocalImage
                ]
                
                // re encode image as a url due to it un-encoding when loaded in
                let size = CGSize(width: 200.0, height: 200.0)
                // unwrap, and resize so firebase doesnt freak out
                if let image = clothing.image {
                    if let resizedImage = resizeImage(image: image, targetSize: size) {
                        if let b64str = convertImageToBase64String(img: resizedImage) {
                            clothingData["imageUrl"] = b64str
                        } else {
                            print("Failed to convert resized image to Base64.")
                        }
                    } else {
                        print("Failed to resize image.")
                    }
                }
                return clothingData
            }
        ]
        
        if let thumbnail = outfit.thumbnail {
            guard let base64String = convertImageToBase64String(img: thumbnail) else {
                print("Error, could not convert thumbnail image...")
                return
            }
            data["thumbnail"] = base64String
        } else {
            data["thumbnail"] = ""
        }
        
        
        db.collection("outfits").document(outfit.itemID).setData(data) { error in
            if let error = error {
                print("Error saving outfit: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Outfit saved successfully.")
                completion(true)
            }
        }
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? { // oh wow i love firebase!!!!!!!!!!!!!!
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let ratio = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    private func convertImageToBase64String(img: UIImage) -> String? {
        guard let imageData = img.jpegData(compressionQuality: 0.01) else { return nil } // i love corporate america :]
        return imageData.base64EncodedString()
    }
}

extension OutfitStore {
    func createNewOutfit(name: String, clothes: [Clothing] = [], thumbnail: UIImage? = nil, completion: @escaping (Bool) -> Void) {
        guard let userID = userSession.userID else {
            print("User is not logged in.")
            completion(false)
            return
        }
        
        let newOutfit = Outfit(
            userID: userID,
            itemID: UUID().uuidString,
            name: name,
            clothes: clothes,
            thumbnail: thumbnail
        )

        saveOutfit(newOutfit) { success in
            completion(success)
        }
    }
}
