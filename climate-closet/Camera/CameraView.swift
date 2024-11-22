import SwiftUI
import Photos
import FirebaseFirestore

struct CameraView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var imageSource: ImagePicker.SourceType = .photoLibrary
    @StateObject private var clothing = Clothing(userID: UserSession.shared.userID ?? "na",
                                                 itemID: "")
    @State private var navigateToImageInfo = false // controls the navigation
    @State private var imageSelected = false // wait for an image to be picked
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack() {
                    // thumbnail or placeholder
                    ZStack {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: geometry.size.height / 2)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(10)
                        } else {
                            Text("Select an image")
                                .foregroundColor(.gray)
                                .frame(maxHeight: geometry.size.height / 2)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                        }
                    }
                    .frame(height: geometry.size.height / 2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // controls
                    VStack {
                        if !imageSelected {
                            VStack {
                                Button("Camera") {
                                    imageSource = .camera
                                    showImagePicker = true
                                }
                                .padding(.bottom, 10)
                                .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                                .font(.title3)
                                
                                Button("Photo Library") {
                                    imageSource = .photoLibrary
                                    showImagePicker = true
                                }
                                .font(.title3)
                            }
                            .padding()
                        }
                        
                        if imageSelected {
                            if let unwrappedImage = selectedImage {
                                NavigationLink(destination: ImageInfoView(image: unwrappedImage, selectedImage: $selectedImage)) {
                                    Text("Proceed to Info")
                                }
                                .font(.title3)
                                .padding()
                            }
                            
                            Button("Remove Image") {
                                selectedImage = nil
                                imageSelected = false // reset state
                                navigateToImageInfo = false // reset nav
                            }
                            .font(.title3)
                            .foregroundColor(.red)
                            .padding()
                        }
                    }
                    .frame(height: geometry.size.height / 2.5)
                }
            }
            .onChange(of: selectedImage) {
                imageSelected = (selectedImage != nil)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: imageSource, selectedImage: $selectedImage)
            }
            .navigationTitle("Add a new item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
