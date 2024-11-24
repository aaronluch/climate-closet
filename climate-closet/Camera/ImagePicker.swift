import SwiftUI

// SwiftUI wrapper, allows users to select an image from their camera or phoot library
struct ImagePicker: UIViewControllerRepresentable {
    enum SourceType {
        case camera, photoLibrary
    }
    
    var sourceType: SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    // Creates and configures a UIImagePickerController based on the selected SourceType
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = (sourceType == .camera && UIImagePickerController.isSourceTypeAvailable(.camera)) ? .camera : .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // Creates a coordinator to handle the image selection logic
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Acts as a delegate for the UIImagePickerController to manage events like image selection and dismissal
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
