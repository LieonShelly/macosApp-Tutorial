//
//  EventLink.swift
//  OnThisDay
//
//  Created by Renjun Li on 2025/7/24.
//

import Foundation

struct EventLink: Decodable, Identifiable {
    let id: UUID
    let title: String
    let url: URL
}
