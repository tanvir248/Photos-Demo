//
//  PhotoDetailsCardView.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 3/9/24.
//

import SwiftUI

struct PhotoDetailsCardView: View {
    var photoWidth: Int
    var photoHeight: Int
    var name: String
    var photoGrapher: String
    var photoGrapherId: String
    var title: String
    var body: some View {
        Form {
            if !title.isEmpty {
                Section("Titile") {
                    Text(title)
                        .font(.headline)
                        .italic()
                }
            }
            Section("Introduction") {
                Text("Image : \(name)")
                    .font(.subheadline)
                    .italic()
                    .bold()
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                Text("Photographer : \(photoGrapher)")
                    .font(.subheadline)
                    .italic()
                    .bold()
                Text("Photographer ID : \(photoGrapherId)")
                    .font(.subheadline)
                    .italic()
                    .bold()
            }
            Section("Configeration") {
                Text("Width : \(String(photoWidth)), Height: \(String(photoHeight))")
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
        let megapixel : Double = Double(Double(photoWidth * photoHeight) / 1000000.0)
        
        
        return String(format: "%.02f", megapixel)
    }
}

#Preview {
    PhotoDetailsCardView(photoWidth: 3616, photoHeight: 5425, name: "pexels-photo-27890690.jpeg", photoGrapher: "yusragonul", photoGrapherId: "1653669305", title: "A tower with a view of the countryside")
}
