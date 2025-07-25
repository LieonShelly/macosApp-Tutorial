//
//  TableView.swift
//  OnThisDay
//
//  Created by Renjun Li on 2025/7/25.
//

import SwiftUI

struct TableView: View {
    var tableData: [Event]
    @AppStorage("showTotals") var showTotals = true
    
    @State private var sortOrder = [KeyPathComparator(\Event.year)]
    @State private var selectedEventID: UUID?
    
    var body: some View {
        HStack {
            Table(
                sortedTableData,
                selection: $selectedEventID,
                sortOrder: $sortOrder
            ) {
                TableColumn("year", value: \.year) {
                    Text($0.year)
                }
                .width(min: 50, ideal: 60, max: 100)
                
                TableColumn("Title", value: \.text)
            }
            if let selectedEvent {
                EventView(event: selectedEvent)
            } else {
                Text("Select an event for more details…")
                  .font(.title3)
                  .padding()
                  .frame(width: 250)
            }
        }
        if showTotals {
            Text("\(tableData.count) \(tableData.count == 1 ? "entry" : "entries") displayed.")
                .padding(.bottom, 8)
        }
    }
    
    var sortedTableData: [Event] {
        return tableData.sorted(using: sortOrder)
    }
    
    var selectedEvent: Event? {
        guard let selectedEventID = selectedEventID else {
            return nil
        }
        
        let event = tableData.first {
            $0.id == selectedEventID
        }
        return event
    }
}

