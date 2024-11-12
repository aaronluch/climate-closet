import SwiftUI
import Photos
import FirebaseFirestore

struct CameraView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var imageSource: ImagePicker.SourceType = .photoLibrary
    @StateObject private var clothing = Clothing(userID: UserSession.shared.userID ?? "na")
    @State private var navigateToImageInfo = false // controls the navigation

    var body: some View {
        NavigationStack {
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
                    NavigationLink(destination: ImageInfoView(userID: clothing.userID, image: unwrappedImage, selectedImage: $selectedImage)) {
                        Text("Proceed to Info")
                    }
                    .padding()
                }


                if selectedImage != nil {
                    Button("Remove Image") {
                        selectedImage = nil
                        navigateToImageInfo = false // reset nav if image is removed
                    }
                    .foregroundColor(.red)
                    .padding()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: imageSource, selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: imageSource, selectedImage: $selectedImage)
            }
            .navigationTitle("Camera View")
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
