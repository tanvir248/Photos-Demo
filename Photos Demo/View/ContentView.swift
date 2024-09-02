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
    @State private var openImage: Bool = false
    @State private var imageAppearCount: Int = 0
    @State private var currentPage: Int = 1
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: layout){
                    ForEach(vm.viewModelPhotos, id: \.src?.original) { photos in
                        if let urlStr = photos.src?.small, let url = URL(string: urlStr),let urlOriginal = photos.src?.original{
                            Button {
                                imageModel.imageURL = urlOriginal
                                imageModel.isOpen = true
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
                            .contextMenu {
                                Button {
                                    imageModel.imageURL = urlOriginal
                                    imageModel.isOpen = true
                                } label: {
                                    Label("Open", systemImage: "globe")
                                }

                                Button{
                                    
                                }label: {
                                    Label("Details", systemImage: "location.circle")
                                }
                            
                                ShareLink(item: URL(string: urlOriginal) ?? url) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }


                            }preview: {
                                if  let urlMedium = photos.src?.medium, let url = URL(string: urlMedium) {
                                    WebImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                                    }.padding(3)
                                     .frame(width: 250, height: 250)
                                }
                            }
                            .onFirstAppear {
                                imageAppearCount += 1
                                if imageAppearCount % 55 == 0 {
                                    currentPage += 1
                                }
                                if imageAppearCount % 55 == 0 && imageAppearCount < vm.totalPhotos {
                                    print("currentPage \(currentPage)")
                                    vm.fetchPhotos(currentPage)
                                }
                            }
                        }
                    }
                }
            }
        }.fullScreenCover(isPresented: $imageModel.isOpen, content: {
            PhotoView(urlString: imageModel.imageURL)
        })
        .onAppear {
            vm.fetchPhotos(1)
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

public extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }
}

struct ViewFirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: () -> Void

    init(perform action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppearBefore else { return }
            didAppearBefore = true
            action()
        }
    }
}
