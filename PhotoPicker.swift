/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import PhotosUI

@available(iOS 15.0, *)
struct PhotoPicker: UIViewControllerRepresentable {
    @EnvironmentObject var dataModel: DataModel
    let imagePredictor = ImagePredictor()
    
    /// A dismiss action provided by the environment. This may be called to dismiss this view controller.
    @Environment(\.dismiss) var dismiss
    
    /// Creates the picker view controller that this object represents.
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> PHPickerViewController {
        
        // Configure the picker.
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        // Limit to images.
        configuration.filter = .images
        configuration.selectionLimit = 0
        // Avoid transcoding, if possible.
        configuration.preferredAssetRepresentationMode = .current

        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    /// Creates the coordinator that allows the picker to communicate back to this object.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Updates the picker while it’s being presented.
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PhotoPicker>) {
        // No updates are necessary.
    }
}

@available(iOS 15.0, *)
class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    let parent: PhotoPicker
    
    /// Called when one or more items have been picked, or when the picker has been canceled.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        // Dismisss the presented picker.
        self.parent.dismiss()
        
        for result in results {
            if !result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                continue
            }
            // Load a file representation of the picked item.
            // This creates a temporary file which is then copied to the app’s document directory for persistent storage.
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                if let error = error {
                    print("Error loading file representation: \(error.localizedDescription)")
                } else if let url = url {
                    self.copyAndPredict(url, result)
                }
            }
            
        }
    }
    
    private func classifyImage(_ image: UIImage, _ url: URL) {
        do {
            try self.parent.imagePredictor.makePredictions(url, image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?, _ url: URL?) {
        guard let url = url else {
            return
        }
        // Add the new item to the data model.
        Task { @MainActor [dataModel = self.parent.dataModel] in
            
            withAnimation {
                let item = Item(url: url)
                item.classify = predictions ?? []
                print("picked url: \(url)")
                dataModel.addItem(item)
            }
        }
    }
    
    private func copyAndPredict(_ url: URL, _ result: PHPickerResult) {
        if let exist = self.parent.dataModel.items.first(where: { it in
            it.url == url
        }) {
            print("alread has this picture ingore: \(url) \(exist)")
            return
        }
        if let savedUrl = FileManager.default.copyItemToDocumentDirectory(from: url) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let error = error {
                    print("Photo picker error: \(error)")
                    return
                }

                guard let photo = object as? UIImage else {
                    fatalError("The Photo Picker's image isn't a/n \(UIImage.self) instance.")
                }

                DispatchQueue.global(qos: .userInitiated).async {
                    self.classifyImage(photo, savedUrl)
                }
            }
        }
    }
    
    init(_ parent: PhotoPicker) {
        self.parent = parent
    }
}
