//
//  ContentView.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 2/9/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct ContentView: View {
    @State var layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @StateObject private var vm = PhotosViewModel()
    @State private var imageModel: LargeImage = LargeImage()
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: layout){
                    ForEach(vm.viewModelPhotos, id: \.src?.original) { photos in
                        if let urlStr = photos.src?.small, let url = URL(string: urlStr) {
                            Button {
                                
                            }label: {
                                WebImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                                }.padding(3)
                            }
                            .frame(height: 120)
                        }
                    }
                }
            }
        }
        .onAppear {
            vm.fetchPhotos()
        }
    }
}

#Preview {
    ContentView()
}

struct LargeImage {
    var isOpen: Bool = false
    var imageURL: String = ""
}
