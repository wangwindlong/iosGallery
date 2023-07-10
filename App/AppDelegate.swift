/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Defines the application's delegate class.
*/

import UIKit
import SwiftUI

//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//}


@available(iOS 16.0, *)
@main
struct ImageGalleryApp: App {
    @StateObject var dataModel = DataModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GridView()
            }
            .environmentObject(dataModel)
            .navigationViewStyle(.stack)
        }
    }
}
