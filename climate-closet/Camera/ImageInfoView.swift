import Foundation
import SwiftUI
import FirebaseFirestore

struct ImageInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    //@State private var userID: String bug?
    @State private var name: String = ""
    @State private var itemID: String = ""
    @State private var owned: Bool = true
    @State private var category: Clothing.Category = .other
    @State private var minTemp: String = ""
    @State private var maxTemp: String = ""
    @State private var imageUrl: String? = nil // base64 encoded as a string for images
    @State private var isLocalImage: Bool = false // false because we remote upload this
    @State private var image: UIImage
    @State private var successUpload = false

    init(image: UIImage, selectedImage: Binding<UIImage?>) {
        //self._userID = State(initialValue: userID)
        self._image = State(initialValue: image)
        self._selectedImage = selectedImage
    }
    
    var body: some View {
            VStack {
                // preview image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()

                // input fields for metadata
                
                // name of clothing object
                TextField("Name", text: $name)
                    .padding()
                
                // state of own / not owned
                Toggle("Owned", isOn: $owned)
                    .padding()
                
                // choose category
                Picker("Category", selection: $category) {
                    ForEach(Clothing.Category.allCases, id: \.self) { category in
                        Text(category.rawValue.capitalized).tag(category)
                    }
                }
                .padding()
                
                // type min temp
                TextField("Min Temperature", text: $minTemp)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // type max temp
                TextField("Max Temperature", text: $maxTemp)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // upload to firestore
                Button("Upload") {
                    uploadImageToFirestore()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
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
                return
            }
            
            guard let base64String = convertImageToBase64String(img: image) else {
                print("Error: Could not convert image to Base64.")
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
                "imageUrl": base64String, // use base64 string as url
                "isLocalImage": isLocalImage
            ]
            
            // upload to firestore part of db
            let db = Firestore.firestore()
            let documentRef = db.collection("clothing").document()
            documentRef.setData(clothingData) { error in
                if let error = error {
                    print("Error uploading clothing: \(error.localizedDescription)")
                } else {
                    documentRef.updateData(["itemID": documentRef.documentID]) // assigns identifier when uploaded to collection
                    print("Clothing item successfully uploaded.")
                    successUpload = true
                    clearImageAndReturn()
                }
            }
        }
        
    
    private func clearImageAndReturn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            selectedImage = nil // clear the image in CameraView
            presentationMode.wrappedValue.dismiss()
        }
    }
        // convert ui image to base64, needs to be very small due to firebase limitations
        private func convertImageToBase64String(img: UIImage) -> String? {
            guard let imageData = img.jpegData(compressionQuality: 0.02) else { return nil }
            return imageData.base64EncodedString()
        }
    }
