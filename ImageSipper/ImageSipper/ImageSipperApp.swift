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
    var serviceProvider = ServiceProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sipsRunner)
                .onAppear {
                    NSApp.servicesProvider = serviceProvider
                }
        }
    }
}
