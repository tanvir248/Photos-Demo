//
//  ContentView.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 2/9/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct ContentView: View {
    @EnvironmentObject var downloadTask: DownloadTaksManager
    @State var layout = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    @StateObject private var vm = PhotosViewModel()
    @State private var imageModel: LargeImage = LargeImage()
    @State private var photoModel: Photo?
    @State private var openImage: Bool = false
    @State private var imageAppearCount: Int = 0
    @State private var currentPage: Int = 1
    @State private var originalImageUrl: String = ""
    @State private var openPhotoDetails: Bool = false
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 1){
                        ForEach(vm.viewModelPhotos, id: \.src?.original) { photo in
                            if let urlStr = photo.src?.small, let url = URL(string: urlStr),let urlOriginal = photo.src?.original{
                                Button {
                                    print(photo.alt ?? "")
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
                                        DispatchQueue.main.async {
                                            self.imageModel.imageURL = urlOriginal
                                            self.imageModel.isOpen = true
                                        }
                                        
                                    } label: {
                                        Label("Open", systemImage: "photo.fill")
                                    }
                                    
                                    Button{
                                        DispatchQueue.main.async {
                                            self.photoModel = photo
                                            self.openPhotoDetails = true
                                        }
                                    }label: {
                                        Label("Details", systemImage: "info.circle")
                                    }
                                    
                                    ShareLink(item: URL(string: urlOriginal) ?? url) {
                                        Label("Share", systemImage: "square.and.arrow.up")
                                    }
                                    
                                    
                                }preview: {
                                    if  let urlMedium = photo.src?.medium, let url = URL(string: urlMedium), let width = photo.width, let height = photo.height {
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
                                //Pagination here
                                .onFirstAppear {
                                    imageAppearCount += 1
                                    if imageAppearCount % 55 == 0 {
                                        currentPage += 1
                                    }
                                    if imageAppearCount % 55 == 0 && imageAppearCount < vm.totalPhotos {
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
            .sheet(isPresented: $openPhotoDetails) {
                ZStack {
                    if let photo = photoModel {
                        PhotoDetailsCardView(photo: photo)
                    }else {
                        Text("Error to show details")
                    }
                }
                .presentationDetents([.height(200), .medium])
                .presentationDragIndicator(.visible)
            }
            .onAppear {
                vm.fetchPhotos(1)
            }
            if downloadTask.isDownloading {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .tint(.white)
                }
            }
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
