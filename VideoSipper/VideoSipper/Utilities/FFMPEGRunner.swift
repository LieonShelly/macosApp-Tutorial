//
//  FFMPEGRunner.swift
//  VideoSipper
//
//  Created by Renjun Li on 2025/7/29.
//

import Foundation

enum ResizeMode {
    case fixedWidth(Int)
    case fixedHeight(Int)
}

class FFMPEGRunner: ObservableObject {
    var commandRunner = CommandRunner()
    
    func getVideData(_ videoPath: String) async {
        let probePahth = await commandRunner.pathTo(command: "ffprobe")
        let arguments = [
            "-v", "quiet",
            "-print_format", "json",
            "-show_format",
            "-show_streams",
            videoPath
        ]
        let result = await commandRunner.runCommand(probePahth, with: arguments)
        let data = result.data(using: .utf8)!
        let response = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        print(response)
    }
    
    func convertToMp4(
        inputPath: String,
        outputPath: String,
        resizeMode: ResizeMode? = nil
    ) async {
        let ffmpegPath = await commandRunner.pathTo(command: "ffmpeg")
        
        var args = [
            "-i", inputPath,
        ]
        if let resizeMode {
            let scaleValue: String
            switch resizeMode {
            case .fixedWidth(let value):
                scaleValue = "\(value):-1"
            case .fixedHeight(let value):
                scaleValue = "-1:\(value)"
            }
            args += ["-vf", "scale=\(scaleValue)"]
        }
        
        args += [
            "-c:v", "libx264",
            "-preset", "fast",
            "-crf", "23",
            "-c:a", "aac",
            "-b:a", "128k",
            "-y", outputPath
        ]
        
        let result = await commandRunner.runCommand(ffmpegPath, with: args)

    }
}
