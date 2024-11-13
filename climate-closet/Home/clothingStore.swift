import Foundation
import SwiftUI
import FirebaseFirestore

class ClothesStore: ObservableObject {
    @ObservedObject var userSession = UserSession.shared
    @Published var allClothes: [Clothing] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        listenForClothingUpdates()
    }

    deinit {
        listener?.remove() // remove listener when ClothesStore is deinitialized
    }

    func listenForClothingUpdates() {
        guard let userID = userSession.userID else {
            print("User is not logged in.")
            return
        }
        
        // listener for clothing items belonging to the current user
        listener = db.collection("clothing")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error listening for clothing updates: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No clothing items found for this user.")
                    return
                }

                self.allClothes = documents.compactMap { doc in
                    let data = doc.data()
                    
                    return self.parseClothingData(data, documentID: doc.documentID)
                }
            }
    }

    private func parseClothingData(_ data: [String: Any], documentID: String) -> Clothing? {
        guard
            let userID = data["userID"] as? String,
            let name = data["name"] as? String,
            let owned = data["owned"] as? Bool,
            let categoryString = data["category"] as? String,
            let category = Clothing.Category(rawValue: categoryString),
            let minTemp = data["minTemp"] as? String,
            let maxTemp = data["maxTemp"] as? String,
            let imageUrl = data["imageUrl"] as? String,
            let isLocalImage = data["isLocalImage"] as? Bool
        else {
            print("Error parsing clothing data.")
            return nil
        }
        
        let itemID = data["itemID"] as? String ?? "" // default to empty string if itemID is missing
        
        let clothing = Clothing(
            userID: userID,
            itemID: itemID,
            name: name,
            owned: owned,
            category: category,
            minTemp: minTemp,
            maxTemp: maxTemp,
            imageUrl: isLocalImage ? imageUrl : nil,
            isLocalImage: isLocalImage
        )

        if !isLocalImage, let imageData = Data(base64Encoded: imageUrl), let decodedImage = UIImage(data: imageData) {
            clothing.image = decodedImage
        }

        return clothing
    }
}
