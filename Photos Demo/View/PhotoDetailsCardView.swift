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
            Section("Titile") {
                HStack(alignment: .top){
                    Text(title)
                        .font(.headline)
                        .italic()
                }
            }
            Section("Introduction") {
                Text("Image")
                Text("Photographer : \(photoGrapher)")
                    .font(.subheadline)
                    .italic()
                    .bold()
                Text("Photographer ID : \(photoGrapherId)")
                    .font(.subheadline)
                    .italic()
                    .bold()
            }
            
        }
    }
}

#Preview {
    PhotoDetailsCardView(photoWidth: 3616, photoHeight: 5425, name: "pexels-photo-27890690.jpeg", photoGrapher: "yusragonul", photoGrapherId: "1653669305", title: "A tower with a view of the countryside")
}
