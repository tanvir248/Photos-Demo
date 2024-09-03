//
//  PhotoDetailsCardView.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 3/9/24.
//

import SwiftUI

struct PhotoDetailsCardView: View {
    var photo: Photo
    var body: some View {
        Form {
            if let title = photo.alt, !title.isEmpty {
                Section("Titile") {
                    Text(title)
                        .font(.headline)
                        .italic()
                }
            }
            Section("Introduction") {
                if let imgUrl = photo.src?.original {
                    Text("Image : \(imageNameFromURL(imgUrl))")
                        .font(.subheadline)
                        .italic()
                        .bold()
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                }
                Text("Photographer : \(photo.photographer ?? "")")
                    .font(.subheadline)
                    .italic()
                    .bold()
                Text("Photographer ID : \(photo.photographerID ?? 0)")
                    .font(.subheadline)
                    .italic()
                    .bold()
            }
            Section("Configeration") {
                Text("Width : \(String(photo.width ?? 0)), Height: \(String(photo.height ?? 0))")
                    .font(.subheadline)
                    .italic()
                    .bold()
                    .lineLimit(2)
                Text("Size : \(photoMegapixel())MP")
                    .font(.subheadline)
                    .italic()
                    .bold()

            }
            
        }
    }
    private func photoMegapixel() -> String {
        let photoWidth = photo.width ?? 0
        let photoHeight = photo.height ?? 0
        let megapixel : Double = Double(Double(photoWidth * photoHeight) / 1000000.0)
        
        
        return String(format: "%.01f", megapixel)
    }
    private func imageNameFromURL(_ url: String) -> String{
        let splitUrl = url.split(separator: "/")
        
        return String(splitUrl.last ?? "")
    }

}

