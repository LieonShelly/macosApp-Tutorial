//
//  CustomImageView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/27.
//

import SwiftUI

struct CustomImageView: View {
    @Binding var imageURL: URL?
    @State private var image: NSImage?
    @State private var dragOver = false
    
    var body: some View {
        Image(nsImage: image ?? NSImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.bottom, 12)
            .onChange(of: imageURL) { oldValue, newValue in
                loadImage()
            }
            .onDrop(
                of: ["public.file-url"],
                isTargeted: $dragOver
            ) { providers in
                if let provider = providers.first {
                    provider.loadDataRepresentation(forTypeIdentifier: "public.file-url") { data, _ in
                        loadURL(from: data)
                    }
                }
                return true
            }
    }
    
    func loadImage() {
        if let imageURL {
            image = NSImage(contentsOf: imageURL)
        } else {
            image = nil
        }
    }
    
    func loadURL(from data: Data?) {
        guard
            let data = data,
            let filePath = String(data: data, encoding: .utf8),
            let url = URL(string: filePath) else {
            return
        }
        
        imageURL = url
    }
}
