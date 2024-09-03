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
    
    @EnvironmentObject var download: DownloadTaksManager

    @State private var offset: CGSize = .zero
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            VStack {
                if let url = URL(string: urlString) {
                    WebImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .offset(totalZoom > 1.0 ? offset : CGSize.zero)
                            .scaleEffect(currentZoom + totalZoom)
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        withAnimation {
                                            offset = value.translation
                                        }
                                    })
                            )
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
                            .onTapGesture(count: 2){
                                withAnimation {
                                    if totalZoom == 1.0 {
                                        currentZoom = 1.0
                                        totalZoom = 2.0
                                    }else {
                                        currentZoom = 0.0
                                        totalZoom = 1.0
                                        offset = .zero
                                    }
                                    
                                }
                            }
                    } placeholder: {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                            .tint(.secondary)
                    }
                }
            }.toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        offset = .zero
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        download.downloadFile(urlString: urlString, fileType: imageNameFromURL(urlString))
                        dismiss()
                    }label: {
                        Text("Download")
                    }
                    
                }

            }
            
        }
    }
    private func imageNameFromURL(_ url: String) -> String{
        let splitUrl = url.split(separator: "/")
        
        return String(splitUrl.last ?? "")
    }

}

#Preview {
    PhotoView(urlString: "https://images.pexels.com/photos/27925463/pexels-photo-27925463.jpeg")
}
