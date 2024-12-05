//
//  Tracker.swift
//  Tracker
//
//  Created by Nurbol on 05.11.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let eventDate: Date?
}
