//
//  TerminalView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/28.
//

import SwiftUI

struct TerminalView: View {
    @ObservedObject var commandRunner: CommandRunner
    
    var body: some View {
        VStack {
            Text("Terminal")
                .font(.headline)
            
            ScrollView {
                Text(commandRunner.output)
                    .foregroundStyle(Color.green)
                    .textSelection(.enabled)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
            }
            .border(Color.gray.opacity(0.3))
            
            Button("Clear") {
                commandRunner.clearOutput()
            }
        }
        .frame(minWidth: 300)
        .padding()
    }
}
