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
                    Text("Width:").frame(width: 50)
                    TextField("", text: $picWidth)
                        .focused($widthFieldHasFocus)
                        .frame(maxWidth: 60)
                }
                
                HStack {
                    Text("height:").frame(width: 50)
                    TextField("", text: $picHeight)
                        .focused($heightFieldHasFocus)
                        .frame(maxWidth: 60)
                }
            }
            Button {
                toggleAspectRatioLock()
            } label: {
                if lockAspectRatio {
                  Image(systemName: "lock")
                } else {
                    Image(systemName: "lock.open")
                }
            }
            .font(.title)
            .buttonStyle(.plain)
            .frame(width: 50)
        }
        .onChange(of: picWidth) { oldValue, newValue in
            if widthFieldHasFocus {
               adjustAspectRatio(newWidth: newValue, newHeight: nil)
            }
        }
        .onChange(of: picHeight) { oldValue, newValue in
            if heightFieldHasFocus {
                adjustAspectRatio(newWidth: nil, newHeight: newValue)
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
