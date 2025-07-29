//
//  ThumbsView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/28.
//

import SwiftUI

struct ThumbsView: View {
    @State private var folderURL: URL?
    @State private var imageURLs: [URL] = []
    @Binding var selectedTab: TabSelection
    @State private var dragOver = false
    
    let serviceReceivedFolderNotification = NotificationCenter.default
      .publisher(for: .serviceReceivedFolder)
      .receive(on: RunLoop.main)
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectImagesFolder()
                } label: {
                    Text("Select Folder of Images")
                }
                
                ScrollingPathView(url: $folderURL)
            }
                .padding()
            
            ScrollView {
                LazyVStack {
                    ForEach(imageURLs, id: \.self) { imageURL in
                        HStack {
                            AsyncImage(url: imageURL) { image in
                                image
                                  .resizable()
                                  .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .padding(.leading)
                            
                            Text(imageURL.lastPathComponent)
                            Spacer()
                        }
                    }
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.bottom, 12)

            Spacer()
            
            ThumbControls(imageURLs: imageURLs)
        }
        .onChange(of: folderURL) { _ in
            if let folderURL = folderURL {
                imageURLs = FileManager.default.imageFiles(in: folderURL)
            } else {
                imageURLs = []
            }
        }
        .onDrop(
            of: ["public.file-url"],
            isTargeted: $dragOver
        ) { providers in
            if let provider = providers.first {
                provider.loadDataRepresentation(
                    forTypeIdentifier: "public.file-url") { data, _ in
                        loadURL(from: data)
                    }
            }
            return true
        }
        .onReceive(serviceReceivedFolderNotification) { notification in
            if let url = notification.object as? URL {
                selectedTab = .makeThumbs
                folderURL = url
            }
        }
    }
    
    
    func selectImagesFolder() {
        let openPanel = NSOpenPanel()
        openPanel.message = "Select a folder of images:"
        
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        
        openPanel.begin { response in
            if response == .OK {
                folderURL = openPanel.url
            }
        }
    }

    func loadURL(from data: Data?) {
        guard
            let data = data,
            let filePath = String(data: data, encoding: .ascii),
            let url = URL(string: filePath) else {
            return
        }
        if FileManager.default.isFolder(url: url) {
            folderURL = url
        }
    }
}

