import SwiftUI
import UIKit

struct CameraView: View {
    @State private var isImagePickerPresented: Bool = false
    @State private var capturedImage: UIImage?

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
            }
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
