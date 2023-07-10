/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

@available(iOS 15.0, *)
struct GridItemView: View {
    let size: Double
    let item: Item
    

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: item.url) { image in
//                let uiImage = asUIImage()
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size, height: size)
            Text(MainViewController.formatPredictions(item.classify).joined(separator: "\n"))
                    .font(.title3)
                    .background(.black)
                    .foregroundStyle(.white)
        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?, _ url: URL? = nil) {
        guard let predictions = predictions else {
            return
        }
        item.classify = predictions
        
//        if url != nil {
//            guard let item = items.first(where: { it in
//                it.url == url
//            }) else {
//                return
//            }
//            item.classify = predictions
//        }
        
        let formattedPredictions = MainViewController.formatPredictions(predictions)
        let predictionString = formattedPredictions.joined(separator: "\n")
        print("on image predicted: \(predictionString)")
//        updatePredictionLabel(predictionString)
        
    }
}

@available(iOS 15.0, *)
struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        if let url = Bundle.main.url(forResource: "mushy1", withExtension: "jpg") {
            GridItemView(size: 50, item: Item(url: url))
        }
    }
}
