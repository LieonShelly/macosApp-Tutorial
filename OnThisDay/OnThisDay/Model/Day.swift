//
//  Day.swift
//  OnThisDay
//
//  Created by Renjun Li on 2025/7/24.
//

import Foundation

struct Day: Decodable {
    let date: String
    let data: [String: [Event]]

    var events: [Event] { data[EventType.events.rawValue] ?? [] }
    var births: [Event] { data[EventType.births.rawValue] ?? [] }
    var deaths: [Event] { data[EventType.deaths.rawValue] ?? [] }

    var displayDate: String {
        date.replacingOccurrences(of: "_", with: " ")
    }
}
