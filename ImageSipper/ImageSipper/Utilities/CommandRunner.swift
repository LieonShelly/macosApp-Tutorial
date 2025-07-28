//
//  CommandRunner.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

class CommandRunner: ObservableObject {
    @Published var output: String = ""

    func runCommand(
        _ command: String,
        with arguments: [String] = []
    ) async -> String {
        publishOutput("> \(command) \(arguments.joined(separator: " "))\n\n")
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = arguments
        
        let outPipe = Pipe()
        let outFile = outPipe.fileHandleForReading
        process.standardOutput = outPipe
        
        let errPipe = Pipe()
        let errFile = errPipe.fileHandleForReading
        process.standardError = errPipe

        do {
            try process.run()
            
            var returnValue = ""
            
            while process.isRunning {
                let newString = getAvaiableData(from: outFile)
                publishOutput(newString)
                returnValue += newString
            }
            let newString = getAvaiableData(from: outFile)
            publishOutput(newString + "\n")
            returnValue += newString
            do {
                if let errorData = try errFile.readToEnd(),
                   let error = String(data: errorData, encoding: .utf8) {
                    print("ERROR:\(error)")
                }
            } catch {
                print("ERROR:\(error)")
            }
            return returnValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch {
            print(error)
        }
        return ""
    }
    
    func pathTo(command: String) async -> String {
        await runCommand("/bin/zsh", with: ["-c", "which \(command)"])
    }
    
    func publishOutput(_ text: String) {
        Task {
            await MainActor.run {
                self.output += text
            }
        }
    }
    
    func clearOutput() {
        output = ""
    }
    
    func getAvaiableData(from fileHandle: FileHandle) -> String {
        let newData = fileHandle.availableData
        if let string = String(data: newData, encoding: .utf8) {
            return string
        }
        return "-"
    }
}
