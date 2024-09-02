//
//  PhotoView.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 2/9/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoView: View {
    var urlString: String
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            VStack {
                if let url = URL(string: urlString) {
                    WebImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(currentZoom + totalZoom)
                             .gesture(
                                 MagnifyGesture()
                                     .onChanged { value in
                                         currentZoom = value.magnification - 1
                                     }
                                     .onEnded { value in
                                         totalZoom += currentZoom
                                         currentZoom = 0
                                     }
                             )
                             .accessibilityZoomAction { action in
                                 if action.direction == .zoomIn {
                                     totalZoom += 1
                                 } else {
                                     totalZoom -= 1
                                 }
                             }
                             .onTapGesture {
                                 withAnimation {
                                     if totalZoom == 1.0 {
                                         currentZoom = 1.0
                                         totalZoom = 2.0
                                     }else {
                                         currentZoom = 0.0
                                         totalZoom = 1.0

                                     }
//                                     currentZoom = 0.0
                                     
                                 }
                             }
                    } placeholder: {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }.toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                    }

                }
            }

        }
    }
}

#Preview {
    PhotoView(urlString: "https://images.pexels.com/photos/27925463/pexels-photo-27925463.jpeg")
}
