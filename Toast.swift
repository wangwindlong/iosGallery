//
//  Toast.swift
//  Vision + CoreML
//
//  Created by 王云龙 on 2023/7/14.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct Toast: View {
    @Binding var isShowing: Bool
    @State var message: String = ""
    
    
    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
        }
        .opacity(isShowing ? 1 : 0)
        .animation(.easeInOut(duration: 0.3))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isShowing = false
            }
        }
    }
}

//struct Toast_Previews: PreviewProvider {
//    static var previews: some View {
//        Toast(isShowing: true, message: "弹出toast")
//    }
//}
