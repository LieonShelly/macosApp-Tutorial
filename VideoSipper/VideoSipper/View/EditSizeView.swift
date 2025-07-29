//
//  EditSizeView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/28.
//

import SwiftUI

struct EditSizeView: View {
    @Binding var picWidth: String
    @Binding var picHeight: String
    @Binding var lockAspectRatio: Bool
    var aspectRatio: Double
    
    @FocusState private var widthFieldHasFocus: Bool
    @FocusState private var heightFieldHasFocus: Bool
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text("height:").frame(width: 50)
                    TextField("", text: $picHeight)
                        .focused($heightFieldHasFocus)
                        .frame(maxWidth: 60)
                }
            }
        }
    }

    func adjustAspectRatio(newWidth: String?, newHeight: String?) {
        if !lockAspectRatio {
            return
        }
        if let newWidth, let picWidthValue = Double(newWidth) {
            let newHeight = Int(picWidthValue / aspectRatio)
            picHeight = "\(newHeight)"
        } else if let newHeight, let picHeightValue = Double(newHeight) {
            let newWidth = Int(picHeightValue * aspectRatio)
            picWidth = "\(newWidth)"
        }
    }
    
    func toggleAspectRatioLock() {
        lockAspectRatio.toggle()
    }
}
