//
//  SipsRunner.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

class SipsRunner: ObservableObject {
    var commandRunner = CommandRunner()
    
    var sipsComandPath: String?
    
    func checkSipsCommandPath() async -> String? {
        if sipsComandPath == nil {
            sipsComandPath = await commandRunner.pathTo(command: "sips")
        }
        return sipsComandPath
    }
    
    func getImageData(for imageURL: URL) async -> String {
        guard let sipsComandPath = await checkSipsCommandPath() else {
            return ""
        }
        let args = ["--getProperty", "all", imageURL.path]
        let imageData = await commandRunner.runCommand(sipsComandPath, with: args)
        return imageData
    }
    
    func resizeImage(
        picture: Picture,
        newWidth: String,
        newHeight: String,
        newFormat: PicFormat
    ) async -> URL? {
        guard let sipsComandPath = await checkSipsCommandPath() else {
            return nil
        }
        let fileManager = FileManager.default
        let suffix = "-> \(newWidth) x \(newHeight)"
        var newURL = fileManager.addSuffix(of: suffix, to: picture.url)
        newURL = fileManager.changeFileExtension(of: newURL, to: newFormat.rawValue)
        
        let args = [
            "--resampleHeightWidth", newHeight, newWidth,
            "--setProperty", "format", newFormat.rawValue,
            picture.url.path(),
            "--out", newURL.path()
        ]
        
        _ = await commandRunner.runCommand(sipsComandPath, with: args)
        return newURL
    }
    
    func createThumbs(
        in folder: URL,
        from imageURLs: [URL],
        maxDimension: String
    ) async {
        guard let sipsComandPath = await checkSipsCommandPath() else {
            return
        }
        for imageURL in imageURLs {
            let args = [
                "--resampleHeightWidthMax", maxDimension,
                imageURL.path(),
                "--out", folder.path()
            ]
            _ = await commandRunner.runCommand(sipsComandPath, with: args)
        }
    }
    
    func prepareForWeb(_ url: URL) async {
        guard let sipsComandPath = await checkSipsCommandPath() else {
            return
        }
        let args = [
            "--resampleHeightWithMax", "800",
            url.path()
        ]
        
        _ = await commandRunner.runCommand(sipsComandPath, with: args)
    }
}
