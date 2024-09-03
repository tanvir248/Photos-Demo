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
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    @StateObject private var vm = PhotosViewModel()
    @State private var imageModel: LargeImage = LargeImage()
    @State private var openImage: Bool = false
    @State private var imageAppearCount: Int = 0
    @State private var currentPage: Int = 1
    @State private var openPhotoDetails: Bool = false
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 1){
                    ForEach(vm.viewModelPhotos, id: \.src?.original) { photo in
                        if let urlStr = photo.src?.small, let url = URL(string: urlStr),let urlOriginal = photo.src?.original{
                            Button {
                                print(photo)
                                imageModel.imageURL = urlOriginal
                                imageModel.isOpen = true
                            }label: {
                                WebImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                                }
                            }
                            .frame(width: (UIScreen.main.bounds.width / 4) - 1,height: (UIScreen.main.bounds.width / 4) - 1)
                            .clipped()
                            .contextMenu {
                                Button {
                                    UIPasteboard.general.string = urlOriginal
                                } label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }
                                Button {
                                    imageModel.imageURL = urlOriginal
                                    imageModel.isOpen = true
                                } label: {
                                    Label("Open", systemImage: "photo.fill")
                                }

                                Button{
                                    openPhotoDetails = true
                                }label: {
                                    Label("Details", systemImage: "info.circle")
                                }
                            
                                ShareLink(item: URL(string: urlOriginal) ?? url) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }


                            }preview: {
                                if  let urlMedium = photo.src?.medium, let url = URL(string: urlMedium) {
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
                            .sheet(isPresented: $openPhotoDetails) {
                                PhotoDetailsCardView(photoWidth: photo.width ?? 0, photoHeight: photo.height ?? 0, name: imageNameFromURL(urlOriginal), photoGrapher: photo.photographer ?? "", photoGrapherId: String(photo.photographerID ?? 0), title: photo.alt ?? "")
                                    .presentationDetents([.height(200), .medium])
                                    .presentationDragIndicator(.visible)
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
    private func imageNameFromURL(_ url: String) -> String{
        let splitUrl = url.split(separator: "/")
        
        return String(splitUrl.last ?? "")
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
