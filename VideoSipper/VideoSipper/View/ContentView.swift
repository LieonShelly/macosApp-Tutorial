//
//  ContentView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var ffmpegRunner: FFMPEGRunner
    @State private var showTerminalOutput = true
    @State private var selectedTab = TabSelection.editImage
    
    var body: some View {
        HSplitView {
            VStack {
                TabView(selection: $selectedTab) {
                    ImageEditView(selectedTab: $selectedTab)
                        .tabItem {
                            Text("Edit Image")
                        }
                        .tag(TabSelection.editImage)
                }
                .padding(.horizontal)
                .padding(.top)
                .frame(minWidth: 650, minHeight: 450)
                
                HStack {
                    Spacer()
                    Button {
                        showTerminalOutput.toggle()
                    } label: {
                        Text(showTerminalOutput ? "Hide Terminal Output" : "Show Terminal Output")
                        Image(systemName: showTerminalOutput ? "chevron.right" : "chevron.left")
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 2)
                }
            }
            if showTerminalOutput {
                TerminalView(commandRunner: ffmpegRunner.commandRunner)
            }
        }
    }
}

#Preview {
    ContentView()
}


class ServiceProvider {
    
    @objc func openFromService(
        _ pboard: NSPasteboard,
        userData: String,
        error: NSErrorPointer
    ) {
        let fileType = NSPasteboard.PasteboardType.fileURL
        guard let filePath = pboard.pasteboardItems?.first?.string(forType: fileType),
        let url = URL(string: filePath) else {
            return
        }
        NSApp.activate()
        
        let fileManager = FileManager.default
        if fileManager.isFolder(url: url) {
            NotificationCenter.default.post(
                name: .serviceReceivedFolder,
                object: url
            )
        } else {
            NotificationCenter.default.post(
                name: .serviceReceivedImage,
                object: url
            )
        }
    }
}
