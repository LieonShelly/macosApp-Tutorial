//
//  ImageEditControls.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/28.
//

import SwiftUI

struct ImageEditControls: View {
    @EnvironmentObject var ffmpegRunner: FFMPEGRunner
    
    @Binding var videoURL: URL?
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
                
                Button("Convert video") {
                    Task {
                        await resizeImage()
                    }
                }
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
    
    func resizeImage() async {
        guard let videoURL else { return }
        guard let picHeight = Int(picHeight) else { return }
       await ffmpegRunner.convertToMp4(
            inputPath: videoURL.path(percentEncoded: false),
            outputPath: FileManager.default.addSuffix(of: "-->.mp4", to: videoURL).path(percentEncoded: false),
            resizeMode: .fixedHeight(picHeight)
        )
    }
}
