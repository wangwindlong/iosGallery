/*
See the License.txt file for this sample’s licensing information.
*/

import Foundation

class DataModel: ObservableObject {
    
    @Published var items: [Item] = []
    
    
    
    init() {
        if let documentDirectory = FileManager.default.documentDirectory {
            let urls = FileManager.default.getContentsOfDirectory(documentDirectory).filter { $0.isImage }
            for url in urls {
                let item = Item(url: url)
                items.append(item)
            }
        }
        
        if let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil) {
            for url in urls {
                let item = Item(url: url)
                items.append(item)
            }
        }
    }
    
    /// Adds an item to the data collection.
    func addItem(_ item: Item) {
        items.insert(item, at: 0)
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try self.imagePredictor.makePredictions(for: item.url,
//                                                        completionHandler: self.imagePredictionHandler)
//            } catch {
//                print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
//            }
//        }
    }
    
    
    
    /// Removes an item from the data collection.
    func removeItem(_ item: Item) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
            FileManager.default.removeItemFromDocumentDirectory(url: item.url)
        }
    }
    
    func updateItems(_ items: [Item]) {
//        for item in items {
//        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?, _ url: URL? = nil) {
        guard let predictions = predictions else {
            return
        }
        
        if url != nil {
            guard let item = items.first(where: { it in
                it.url == url
            }) else {
                return
            }
            item.classify = predictions
        }
        
//        let formattedPredictions = MainViewController.formatPredictions(predictions)
//
//        let predictionString = formattedPredictions.joined(separator: "\n")
//        updatePredictionLabel(predictionString)
        
    }
}

extension URL {
    /// Indicates whether the URL has a file extension corresponding to a common image format.
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "heic"]
        return imageExtensions.contains(self.pathExtension)
    }
}

