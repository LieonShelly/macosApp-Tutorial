//
//  ContentView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sipsRunner: SipsRunner
    @State private var showTerminalOutput = true
    @State private var selectedTab = TabSelection.editImage
    
    
    var body: some View {
        HSplitView {
            VStack {
                TabView(selection: $selectedTab) {
                    ImageEditView(selectedTab: $selectedTab)
                        .tabItem {
                            Text("Edit Image")
                        }
                        .tag(TabSelection.editImage)
                }
                .padding(.horizontal)
                .padding(.top)
                .frame(minWidth: 650, minHeight: 450)
                
                HStack {
                    Spacer()
                    Button {
                        showTerminalOutput.toggle()
                    } label: {
                        Text(showTerminalOutput ? "Hide Terminal Output" : "Show Terminal Output")
                        Image(systemName: showTerminalOutput ? "chevron.right" : "chevron.left")
                    }
                    .padding([.horizontal, .bottom])
                    .padding(.top, 2)
                }
            }
            if showTerminalOutput {
                TerminalView(commandRunner: sipsRunner.commandRunner)
            }
        }
    }
}

#Preview {
    ContentView()
}


import SwiftUI

struct TerminalView: View {
    @ObservedObject var commandRunner: CommandRunner
    
    var body: some View {
        VStack {
            Text("Terminal")
                .font(.headline)
            
            ScrollView {
                Text(commandRunner.output)
                    .textSelection(.enabled)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
            }
            .foregroundColor(Color("TerminalText"))
            .background(Color("TerminalBg"))
            .border(Color.gray.opacity(0.3))
            
            Button("Clear") {
                commandRunner.clearOutput()
            }
        }
        .frame(minWidth: 300)
        .padding()
    }
}
