import SwiftUI
import UIKit
import Photos

struct CameraView: View {
    @State private var isImagePickerPresented: Bool = false
    @State private var capturedImage: UIImage?
    @State private var showSaveAlert: Bool = false
    @State private var saveError: Error?
    
    var body: some View {
        VStack {
            
            Button(action: {
                isImagePickerPresented = true
            }) {
                Text("Open Camera")
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(capturedImage: $capturedImage)
            }
            
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                    .padding()
                
                Button(action: saveImage) {
                    
                }
            }
        }
    }
    
    private func saveImage() {
        guard let image = capturedImage else { return }
        
        // request permission
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                saveImageToLibrary(image)
            }
            else {
                self.saveError = NSError(domain: "Permission Denied", code: 1)
                self.showSaveAlert = true
            }
        }
    }
    
    private func saveImageToLibrary(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            if let error = error {
                self.saveError = error
            } else if success {
                self.saveError = nil
            }
            self.showSaveAlert = true
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
