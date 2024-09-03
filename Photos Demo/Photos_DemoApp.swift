//
//  Photos_DemoApp.swift
//  Photos Demo
//
//  Created by Tanvir Rahman on 2/9/24.
//

import SwiftUI

@main
struct Photos_DemoApp: App {
    @StateObject var downloadTask = DownloadTaksManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(downloadTask)
        }
    }
}
