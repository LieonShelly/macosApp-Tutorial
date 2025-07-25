//
//  Toolbar.swift
//  OnThisDay
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

struct Toolbar: CustomizableToolbarContent {
    @Binding var viewMode: ViewMode
    
    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "toggleSidebar", placement: .navigation, showsByDefault: true) {
            Button {
                toffgeSidebar()
            } label: {
                Label("Toggle Sidebar", systemImage: "sidebar.left")
            }
            .help("Toggle Sidebar")
        }
        
        ToolbarItem(id: "viewMode") {
            Picker("View Mode", selection: $viewMode) {
                Label("Grid", systemImage: "square.grid.3x2")
                  .tag(ViewMode.grid)
                Label("Table", systemImage: "tablecells")
                  .tag(ViewMode.table)
            }
            .pickerStyle(.segmented)
            .help("Switch between Grid and Table")
        }
        
    }
    
    func toffgeSidebar() {
        NSApp.keyWindow?.contentViewController?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
