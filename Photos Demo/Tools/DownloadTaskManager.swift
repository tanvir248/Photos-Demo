//
//  DownloadTaskManager.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 03.09.2024.
//

import Foundation
import AVKit
import SwiftUI

class DownloadTaksManager: NSObject, ObservableObject, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate{
    @Published var downloadTaskSession : URLSessionDownloadTask!
    @Published var downloadUrl: URL!
    @Published var isDownloading = false
    @Published var isDownloaded = false
    
    @Published var downloadProgress: CGFloat = 0
    @Published var alertMsg = ""
    @Published var showAlert = false
    @Published var showDownloadProgress: Bool = false
    @Published var fileTypes: String = ""

    func downloadFile(urlString: String, fileType: String) {
        self.fileTypes = "\(fileType)"
        DispatchQueue.main.async {
            self.isDownloading = true
        }
        
        if urlString.isEmpty {
            DispatchQueue.main.async {
                self.isDownloading = false
            }
        }
        //check the url....!
        guard let validURL = URL(string: urlString) else {
            print("url isn't valid!")
            return
        }
        //preventing downloading the same file
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if FileManager.default.fileExists(atPath: directoryPath.appendingPathComponent(validURL.lastPathComponent).path){
            print("Yes File founded!")
            
            DispatchQueue.main.async {
                self.isDownloading = false
                let controller = UIDocumentInteractionController(url:  directoryPath.appendingPathComponent(validURL.lastPathComponent))
                controller.delegate = self
                controller.presentPreview(animated: true)
                
            }
            
            return
        }else {
            print("No File founded! ")
            withAnimation{
                self.showDownloadProgress = true
                
            }
            
            self.downloadProgress = 0
            withAnimation{
                self.showDownloadProgress = true
                
            }
            //Download Task
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            self.downloadTaskSession = session.downloadTask(with: validURL)
            self.downloadTaskSession.resume()
        }
    }
    
    func reportError(error: String) {
        alertMsg = error
        showAlert.toggle()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(location)
        
        guard let _ = downloadTask.originalRequest?.url else {
            DispatchQueue.main.async {
                self.reportError(error: "Error File Saving!")
            }
            return
        }
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //destination url // here working withname...!
        let destinationURL = directoryPath.appendingPathComponent(fileTypes)
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                withAnimation{
                    self.showDownloadProgress = false
                    self.isDownloading = false
                }
                
                let controller = UIDocumentInteractionController(url: destinationURL)
                controller.delegate = self
                controller.presentPreview(animated: true)
            }
        }catch {
            self.reportError(error: "Please try again later!")
        }
    }
    
    //getting progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            if progress >= 1.0 {
                self.isDownloading = false
            }
            self.downloadProgress = progress
            
        }
    }
    
    //catch error
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                // print(error.localizedDescription)
                withAnimation{self.showDownloadProgress = false}
                self.reportError(error: error.localizedDescription)
                return
            }
        }
        
    }
    
    
    func cancleDownloadTask(){
        if let task = downloadTaskSession,task.state == .running {
            downloadTaskSession.cancel()
            withAnimation{
                self.showDownloadProgress = false
            }
        }
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.currentUIWindow()!.rootViewController!
    }
}
public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        
        return window
        
    }
}
