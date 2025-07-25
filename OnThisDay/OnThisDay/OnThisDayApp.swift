//
//  OnThisDayApp.swift
//  OnThisDay
//
//  Created by Renjun Li on 2025/7/24.
//

import SwiftUI

@main
struct OnThisDayApp: App {
    @StateObject var appState = AppState()
    @AppStorage("displayMode") var displayMode = DisplayMode.auto
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onAppear {
                    DisplayMode.changeDisplayMode(to: displayMode)
                }
                .onChange(of: displayMode) { oldValue, newValue in
                    DisplayMode.changeDisplayMode(to: displayMode)
                }
        }
        .commands {
            Menus()
        }
        
        Settings {
            PreferencesView()
        }
    }
}
