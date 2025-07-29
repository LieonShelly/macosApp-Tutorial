//
//  VideoSipperApp.swift
//  VideoSipper
//
//  Created by Renjun Li on 2025/7/29.
//

import SwiftUI

@main
struct VideoSipperApp: App {
    @StateObject var ffmpegRunner = FFMPEGRunner()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ffmpegRunner)
        }
    }
}
