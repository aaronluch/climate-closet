import Foundation
import SwiftUI
import FirebaseFirestore

struct OutfitSelectorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var outfitStore: OutfitStore
    @EnvironmentObject var userSession: UserSession // Observe user session changes
    let onOutfitSelected: (Outfit) -> Void
    @State private var unplannedOutfits: [Outfit] = [] // Local to hold unplanned outfits
    @State private var listener: ListenerRegistration?

    var body: some View {
        NavigationView {
            VStack {
                if unplannedOutfits.isEmpty {
                    Text("No outfits available.")
                        .font(.headline)
                        .padding()
                } else {
                    List(unplannedOutfits, id: \.itemID) { outfit in
                        Button(action: {
                            onOutfitSelected(outfit)
                            presentationMode.wrappedValue.dismiss() // Dismiss view
                        }) {
                            HStack {
                                if let thumbnail = outfit.thumbnail {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                } else {
                                    Rectangle()
                                        .fill(Color.gray)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                }
                                Text(outfit.name)
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select an outfit to upload")
            .onAppear {
                startListeningForChanges()
            }
            .onDisappear {
                stopListeningForChanges()
            }
        }
    }

    private func fetchUnplannedOutfits() {
        unplannedOutfits = outfitStore.allOutfits.filter { !$0.isPlanned }
    }

    private func startListeningForChanges() {
        guard let userID = userSession.userID else {
            print("Error: User is not logged in.")
            return
        }
        listener = Firestore.firestore().collection("outfits")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error listening for outfits: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No outfits found.")
                    return
                }
                outfitStore.allOutfits = documents.compactMap { doc in
                    outfitStore.parseOutfitData(doc.data(), documentID: doc.documentID)
                }
                fetchUnplannedOutfits() // Update the unplanned outfits list
            }
    }

    private func stopListeningForChanges() {
        listener?.remove()
        listener = nil
    }
}
