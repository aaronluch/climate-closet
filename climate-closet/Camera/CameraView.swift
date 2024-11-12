import SwiftUI
import Photos
import FirebaseFirestore

struct CameraView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var imageSource: ImagePicker.SourceType = .photoLibrary
    @StateObject private var clothing = Clothing(userID: UserSession.shared.userID ?? "")

    var body: some View {
        NavigationView {
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Select an image")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Button("Camera") {
                        imageSource = .camera
                        showImagePicker = true
                    }
                    .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))

                    Button("Photo Library") {
                        imageSource = .photoLibrary
                        showImagePicker = true
                    }
                }
                .padding()
                
                if let unwrappedImage = selectedImage {
                    NavigationLink(destination: ImageInfoView(clothing: clothing, selectedImage: unwrappedImage, onSave: uploadToFirebase)) {
                        Text("Proceed to Info")
                    }
                    .padding()
                }

                
                if selectedImage != nil {
                    Button("Remove Image") {
                        selectedImage = nil
                    }
                    .foregroundColor(.red)
                    .padding()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: imageSource, selectedImage: $selectedImage)
            }
            .navigationTitle("Camera View")
        }
    }
    
    private func uploadToFirebase() {
        guard let image = clothing.image else { return }
        // Add code to upload `clothing` object and `image` to Firebase
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
