//
//  GridView.swift
//  OnThisDay
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

struct GridView: View {
    var gridData: [Event]
    @AppStorage("showTotals") var showTotals = true
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 250, maximum: 250), spacing: 20)]
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(gridData) {
                        EventView(event: $0)
                            .frame(height: 350, alignment: .topLeading)
                            .background()
                            .clipped()
                            .border(.secondary, width: 1)
                            .padding(.bottom, 5)
                            .shadow(color: .primary.opacity(0.3), radius: 3, x: 3, y: 3)
                    }
                }
            }
            .padding(.vertical)
            
            if showTotals {
                Text("\(gridData.count) \(gridData.count == 1 ? "entry" : "entries") displayed.")
                    .padding(.bottom, 8)
            }
        }
    }
}
