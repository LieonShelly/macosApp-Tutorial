//
//  ImageSipperApp.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

@main
struct ImageSipperApp: App {
    @StateObject var sipsRunner = SipsRunner()
  
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sipsRunner)
        }
    }
}


enum TabSelection {
    case editImage
    case makeThumbs
}
