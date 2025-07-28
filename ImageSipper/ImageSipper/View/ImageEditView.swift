//
//  ImageEditView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/27.
//

import SwiftUI

struct ImageEditView: View {
    @EnvironmentObject var sipsRunner: SipsRunner
    @State private var imageURL: URL?
    @State private var image: NSImage?
    @State private var picture: Picture?
    @Binding var selectedTab: TabSelection
    let serviceReceivedImageNotification = NotificationCenter.default.publisher(for: .serviceReceivedImage)
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectImageFile()
                } label: {
                    Text("Select Image File")
                }
                
                ScrollingPathView(url: $imageURL)
            }
                .padding()
            
            CustomImageView(imageURL: $imageURL)
            
            Spacer()
            
            ImageEditControls(imageURL: $imageURL, picture: $picture)
            
        }
        .onChange(of: imageURL) { oldValue, newValue in
            Task {
                await getImageData()
            }
        }
        .onReceive(serviceReceivedImageNotification) { notification in
            if let url = notification.object as? URL {
                selectedTab = .editImage
                imageURL = url
            }
        }
    }
    
    func getImageData() async {
        guard let imageURL = imageURL, FileManager.default.isImageFile(url: imageURL) else {
            print("-----")
            return
        }
        let imageData = await sipsRunner.getImageData(for: imageURL)
        picture = Picture(url: imageURL, sipsData: imageData)
        print("picture:\(picture)")
    }
    
    func selectImageFile() {
        let openPanel = NSOpenPanel()
        openPanel.message = "Select an image file:"
        
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedContentTypes = [.image]
        
        openPanel.begin { response in
            if response == .OK {
                imageURL = openPanel.url
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
