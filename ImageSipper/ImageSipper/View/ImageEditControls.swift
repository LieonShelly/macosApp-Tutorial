//
//  ImageEditControls.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/28.
//

import SwiftUI

struct ImageEditControls: View {
    @EnvironmentObject var sipsRunner: SipsRunner
    
    @Binding var imageURL: URL?
    @Binding var picture: Picture?
    
    @State private var picWidth = ""
    @State private var picHeight = ""
    @State private var lockAspectRatio = true
    @State private var picFormat = PicFormat.png
    
    var body: some View {
        GroupBox {
            HStack {
                EditSizeView(
                    picWidth: $picWidth,
                    picHeight: $picHeight,
                    lockAspectRatio: $lockAspectRatio,
                    aspectRatio: picture?.aspectRatio ?? 1
                )
                Spacer()
                Picker("Format", selection: $picFormat) {
                    ForEach(PicFormat.allCases, id: \.self) { format in
                        Text(format.rawValue).tag(format)
                    }
                }
                .frame(maxWidth: 120)
                
                Spacer()
                
                Button("Resize Image") {
                    Task {
                        await resizeImage()
                    }
                }
                .disabled(!pictureHasChanged)
            }
            .padding(.horizontal)
        }
        .padding([.horizontal, .bottom])
        .onChange(of: picture) { oldValue, newValue in
            if let picture {
                picWidth = "\(picture.pixelWidth)"
                picHeight = "\(picture.pixelHeight)"
                picFormat = PicFormat(rawValue: picture.format) ?? .png
            } else {
                picWidth = ""
                picHeight = ""
                picFormat = .png
            }
        }
    }
    
    var pictureHasChanged: Bool {
        guard let picture else {
            return false
        }
        if picWidth != "\(picture.pixelWidth)" { return true }
        if picHeight != "\(picture.pixelHeight)" { return true }
        if picFormat != PicFormat(rawValue: picture.format) { return true }
        return false
    }
    
    func resizeImage() async {
        guard let picture else { return }
        imageURL = await sipsRunner.resizeImage(
            picture: picture,
            newWidth: picWidth,
            newHeight: picHeight,
            newFormat: picFormat
        )
    }
}


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
