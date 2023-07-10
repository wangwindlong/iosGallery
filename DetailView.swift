/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct DetailView: View {
    let item: Item

    var body: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: item.url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        if let url = Bundle.main.url(forResource: "mushy1", withExtension: "jpg") {
            DetailView(item: Item(url: url))
        }
    }
}
