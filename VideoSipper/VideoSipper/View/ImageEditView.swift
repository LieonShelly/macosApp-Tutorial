//
//  ImageEditView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/27.
//

import SwiftUI

struct ImageEditView: View {
    @EnvironmentObject var ffmpegRunner: FFMPEGRunner
    @State private var imageURL: URL?
    @State private var videoURL: URL?
    @State private var image: NSImage?
    @State private var picture: Picture?
    @Binding var selectedTab: TabSelection
    let serviceReceivedImageNotification = NotificationCenter.default.publisher(for: .serviceReceivedImage)
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectVideoFile()
                } label: {
                    Text("Select Video File")
                }
                
                ScrollingPathView(url: $videoURL)
            }
                .padding()
            
//            CustomImageView(imageURL: $imageURL)
            
            Spacer()
            
            ImageEditControls(videoURL: $videoURL, picture: $picture)
            
        }
        .onChange(of: videoURL) { oldValue, newValue in
            Task {
                await getVideoData()
            }
        }
        .onReceive(serviceReceivedImageNotification) { notification in
            if let url = notification.object as? URL {
                selectedTab = .editImage
                videoURL = url
            }
        }
    }
    
    func getVideoData() async {
        guard let videoURL, FileManager.default.isVideoFile(url: videoURL) else {
            return
        }
        let videoData = await ffmpegRunner.getVideData(videoURL.path(percentEncoded: false))
    }
    
    
    func selectVideoFile() {
        let openPanel = NSOpenPanel()
        openPanel.message = "Select an image file:"
        
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.image, .video, .movie]
        
        openPanel.begin { response in
            if response == .OK {
                videoURL = openPanel.url
                
            }
        }
    }
    
}

extension Notification.Name {
    static let serviceReceivedImage =
    Notification.Name("serviceReceivedImage")
    static let serviceReceivedFolder =
    Notification.Name("serviceReceivedFolder")
}
