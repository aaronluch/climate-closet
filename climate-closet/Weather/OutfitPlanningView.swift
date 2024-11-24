import SwiftUI
import Foundation

// Users can plan and create new outfits by selecting clothing items
// Saves outfit to firestore db
struct OutfitPlanningView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var expandedCategories: [Clothing.Category: Bool] = [:]
    @State private var selectedClothes: [Clothing] = []
    @State private var thumbnailImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var outfitName = ""
    @State private var successUpload = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Clothing.Category.allCases, id: \.self) { category in
                    ExpandableClothingCategoryView(
                        category: category,
                        clothes: clothesStore.allClothes.filter { $0.category == category },
                        isExpanded: Binding(
                            get: { expandedCategories[category, default: false] },
                            set: { expandedCategories[category] = $0 }
                        ),
                        selectedClothing: .constant(nil), // Not used in selecting mode
                        mode: .selecting,
                        selectedClothes: $selectedClothes
                    )
                }
                // name outfit
                TextField(
                    "Enter name of outfit",
                    text: $outfitName
                )
                .padding()
                .frame(width: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                // thumbnail
                if let thumbnailImage = thumbnailImage {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: thumbnailImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                        
                        Button(action: {
                            self.thumbnailImage = nil // clear thumbnail image
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.red)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .offset(x: 10, y: 10)
                    }
                } else {
                    Button(action: {
                        // trigger image picker
                        isShowingImagePicker = true
                    }) {
                        Text("Add Thumbnail")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                // create new outfit button
                Button(action: {
                    outfitStore.createNewOutfit(
                        name: outfitName,
                        clothes: selectedClothes,
                        isPlanned: true,
                        thumbnail: thumbnailImage
                    ) { success in
                        if success {
                            successUpload = true
                            selectedClothes.removeAll()
                        } else {
                            print("Failed to save outfit.")
                        }
                    }
                }) {
                    Text(successUpload ? "Outfit Saved" : "Save Outfit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(successUpload ? Color.gray : Color.blue)
                        .foregroundColor(successUpload ? Color.white.opacity(0.7) : Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(successUpload) // disable button after success
                .padding(.top, 20)
            }
            .navigationTitle("Create Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $thumbnailImage)
        }
        .onAppear {
            initializeExpandedCategories()
        }
    }
    
    private func initializeExpandedCategories() {
        for category in Clothing.Category.allCases {
            expandedCategories[category] = expandedCategories[category] ?? false
        }
    }
}
