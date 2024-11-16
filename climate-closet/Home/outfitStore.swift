import Foundation
import SwiftUI
import FirebaseFirestore

class OutfitStore: ObservableObject {
    @ObservedObject var userSession = UserSession.shared
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
                
                let outfits = documents.compactMap { doc in
                    let data = doc.data()
                    return self.parseOutfitData(data, documentID: doc.documentID)
                }
                
                self.allOutfits = outfits
                for outfit in self.allOutfits {
                    self.populateClothes(for: outfit)
                }
            }
    }
    
    private func parseOutfitData(_ data: [String: Any], documentID: String) -> Outfit? {
        guard
            let userID = data["userID"] as? String,
            let clothingIDs = data["clothingIDs"] as? [String],
            let name = data["name"] as? String
        else {
            print("Error parsing outfit data.")
            return nil
        }
        
        let itemID = data["itemID"] as? String ?? ""
        
        let outfit = Outfit(
            userID: userID,
            itemID: itemID,
            clothingIDs: clothingIDs,
            name: name
        )
        
        return outfit
    }
    
    private func populateClothes(for outfit: Outfit) {
        let clothesStore = ClothesStore()
        outfit.clothes = clothesStore.allClothes.filter { outfit.clothingIDs.contains($0.itemID)
        }
    }
}
