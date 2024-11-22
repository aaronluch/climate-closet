import Foundation
import SwiftUI
import FirebaseFirestore

struct ImageInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    @State private var name: String = ""
    @State private var owned: Bool = true
    @State private var category: Clothing.Category = .other
    @State private var minTemp: String = ""
    @State private var maxTemp: String = ""
    @State private var imageUrl: String? = nil // base64 encoded as a string for images
    @State private var isLocalImage: Bool = false // false because we remote upload this
    @State private var image: UIImage
    @State private var successUpload = false
    @State private var buttonDisabled = false // prevent multiple uploads
    
    init(image: UIImage, selectedImage: Binding<UIImage?>) {
        self._image = State(initialValue: image)
        self._selectedImage = selectedImage
    }
    
    // validation check
    private var isFormValid: Bool {
        !name.isEmpty && !minTemp.isEmpty && !maxTemp.isEmpty
    }
    
    var body: some View {
        VStack {
            // image thumbnail
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding(.horizontal, 5)
                .padding(.vertical)
            
            // input fields for metadata
            VStack(spacing: 15) {
                // Name
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 50)
                    TextField("Name", text: $name)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 5)
                
                // Min Temperature
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 50)
                    TextField("Min Temperature", text: $minTemp)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 5)
                
                // Max Temperature
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 50)
                    TextField("Max Temperature", text: $maxTemp)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 5)
                
                // Category
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 50)
                    Picker("Category", selection: $category) {
                        ForEach(Clothing.Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 5)
                
                // Owned State Toggle
                Toggle("Owned", isOn: $owned)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: 400)
            
            // upload
            Button(action: {
                buttonDisabled = true
                uploadImageToFirestore()
            }) {
                Text("Upload")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(buttonDisabled || !isFormValid ? Color.gray.opacity(0.2) : Color.blue)
                    .foregroundColor(buttonDisabled || !isFormValid ? Color.red : Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(buttonDisabled || !isFormValid ? Color.red : Color.blue, lineWidth: 2)
                    )
            }
            .disabled(buttonDisabled || !isFormValid)
            .padding(.top, 20)
            
            // success
            if successUpload {
                Text("Success! Returning...")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
    }
    
    // convert image to base64 and upload with metadata
    private func uploadImageToFirestore() {
        guard let userID = UserSession.shared.userID else {
            print("Error: User ID not available")
            buttonDisabled = false
            return
        }
        
        guard let base64String = convertImageToBase64String(img: image) else {
            print("Error: Could not convert image to Base64.")
            buttonDisabled = false
            return
        }
        
        imageUrl = base64String
        
        // clothing data dictionary for Firestore
        let clothingData: [String: Any] = [
            "userID": userID,
            "name": name,
            "owned": owned,
            "category": category.rawValue,
            "minTemp": minTemp,
            "maxTemp": maxTemp,
            "imageUrl": base64String, // use base64 string as URL
            "isLocalImage": isLocalImage
        ]
        
        // upload to Firestore
        let db = Firestore.firestore()
        let documentRef = db.collection("clothing").document()
        documentRef.setData(clothingData) { error in
            if let error = error {
                print("Error uploading clothing: \(error.localizedDescription)")
                buttonDisabled = false
            } else {
                documentRef.updateData(["itemID": documentRef.documentID]) // assign id on upload
                print("Clothing item successfully uploaded.")
                successUpload = true
                clearImageAndReturn()
            }
        }
    }
    
    // convert UIImage to base64, ensure small size for Firebase
    private func convertImageToBase64String(img: UIImage) -> String? {
        guard let imageData = img.jpegData(compressionQuality: 0.02) else { return nil }
        return imageData.base64EncodedString()
    }
    
    private func clearImageAndReturn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            selectedImage = nil
            presentationMode.wrappedValue.dismiss()
        }
    }
}
