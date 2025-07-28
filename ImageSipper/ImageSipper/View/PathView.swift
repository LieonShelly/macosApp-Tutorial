//
//  PathView.swift
//  ImageSipper
//
//  Created by Renjun Li on 2025/7/27.
//

import SwiftUI

struct PathView: NSViewRepresentable {
    var url: URL?
    
    func makeNSView(context: Context) -> NSPathControl {
        let pathControl = NSPathControl()
        pathControl.isEditable = false
        pathControl.focusRingType = .none
        pathControl.pathStyle = .standard
        
        pathControl.target = context.coordinator
        pathControl.doubleAction = #selector(Coordinator.handleDoubleClick(sender:))
        return pathControl
    }
    
    func updateNSView(_ nsView: NSPathControl, context: Context) {
        nsView.url = url
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        @objc func handleDoubleClick(sender: NSPathControl) {
            if let url = sender.clickedPathItem?.url {
                NSWorkspace.shared.selectFile(
                    url.path(percentEncoded: false),
                    inFileViewerRootedAtPath: ""
                )
            } 
        }
    }
}
