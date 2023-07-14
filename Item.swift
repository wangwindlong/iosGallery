/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

class Item: Identifiable {
    
    init(url: URL) {
        self.url = url
    }

    let id = UUID()
    let url: URL
    
    var classify: [ImagePredictor.Prediction] = []

}


extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
