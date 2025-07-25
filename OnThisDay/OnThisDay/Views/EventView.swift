//
//  EventView.swift
//  OnThisDay
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

struct EventView: View {
    var event: Event
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 30) {
                Text(event.year)
                  .font(.title)

                Text(event.text)
                  .font(.title3)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Related Links:")
                      .font(.title2)
                    
                    ForEach(event.links) { link in
                        Link(link.title, destination: link.url)
                            .onHover { inside in
                                if inside {
                                    NSCursor.pointingHand.push()
                                } else {
                                    NSCursor.pop()
                                }
                            }
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
        .padding()
        .frame(width: 250)
    }
}
