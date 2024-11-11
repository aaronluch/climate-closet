import SwiftUI
import UIKit
import Photos

struct CameraView: View {
    @State private var isImagePickerPresented: Bool = false
    @State private var capturedImage: UIImage?
    @State private var showSaveAlert: Bool = false
    @State private var saveError: Error?
    @State private var isSimulator: Bool = false
    
    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(10)
                    .padding()
                
                Button(action: saveImage) {
                    Text("Save to Library")
                }
                .alert(isPresented: $showSaveAlert) {
                    Alert(
                        title: Text(saveError == nil ? "Saved" : "Error"),
                        message: Text(saveError?.localizedDescription ?? "Image saved to library."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            } else if isSimulator {
                Text("Camera is not supported in Simulator. Please use a real device.")
                    .padding()
            }
        }
        .onAppear {
            checkIfSimulator()
            requestCameraPermission()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(capturedImage: $capturedImage)
        }
    }
    
    private func checkIfSimulator() {
        #if targetEnvironment(simulator)
        isSimulator = true
        #else
        isSimulator = false
        #endif
    }
    
    private func requestCameraPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    if !isSimulator {
                        isImagePickerPresented = true
                    }
                } else {
                    self.saveError = NSError(domain: "Permission Denied", code: 1)
                    self.showSaveAlert = true
                }
            }
        }
    }
    
    private func saveImage() {
        guard let image = capturedImage else { return }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.saveError = error
                } else if success {
                    self.saveError = nil
                }
                self.showSaveAlert = true
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
