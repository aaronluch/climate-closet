import SwiftUI
import Foundation

// Allows users to create a new outfit by selecting clothes, assigning a name and thumbnail
// Manages state for the selected clothes and thumbnail, validates inputs, and saves the outfit to the store
struct CreateOutfitView: View {
    @EnvironmentObject var clothesStore: ClothesStore
    @EnvironmentObject var outfitStore: OutfitStore
    @State private var expandedCategories: [Clothing.Category: Bool] = [:]
    @State private var selectedClothes: [Clothing] = []
    @State private var thumbnailImage: UIImage?
    @State private var isShowingImagePicker = false
    @State private var outfitName = ""
    @State private var successMessage = false
    @State private var buttonDisabled = false
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
                        HStack {
                            Image(systemName: "photo")
                                .font(.headline)
                            Text("Add Thumbnail")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal)
                    }
                }
                
                
                if successMessage {
                    Text("Success! Returning...")
                        .foregroundColor(.green)
                        .padding()
                }
                
                // create new outfit button
                Button(action: {
                    buttonDisabled = true
                    outfitStore.createNewOutfit(
                        name: outfitName,
                        clothes: selectedClothes,
                        thumbnail: thumbnailImage
                    ) { success in
                        if success {
                            selectedClothes.removeAll()
                            successMessage = true
                            clearAndReturn()
                        } else {
                            print("Failed to save outfit.")
                            buttonDisabled = false
                        }
                    }
                }) {
                    Text("Save Outfit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(buttonDisabled || outfitName.isEmpty || selectedClothes.isEmpty ? Color.gray.opacity(0.2) : Color.blue)
                        .foregroundColor(buttonDisabled || outfitName.isEmpty || selectedClothes.isEmpty ?
                                         Color.red : Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(buttonDisabled || outfitName.isEmpty || selectedClothes.isEmpty ?
                                        Color.red : Color.blue, lineWidth: 2)
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                }
                .disabled(buttonDisabled || selectedClothes.isEmpty || outfitName.isEmpty)
            }
            .navigationTitle("Create Outfit")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 10)
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $thumbnailImage)
        }
        .onAppear {
            initializeExpandedCategories()
        }
    }
    
    // Initialize the expansion state of drop down categories
    private func initializeExpandedCategories() {
        for category in Clothing.Category.allCases {
            expandedCategories[category] = expandedCategories[category] ?? false
        }
    }
    
    // Reset the form and return to previous view after delay
    private func clearAndReturn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
