//
//  DataManager.swift
//  Tracker
//
//  Created by Nurbol on 18.11.2024.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Уборка",
            trackers: [
                Tracker(id: UUID(), title: "Помыть посуду", color: .blue, emoji: "🏓", schedule: [WeekDay.saturday, WeekDay.sunday]),
                Tracker(id: UUID(), title: "Погладить одежду", color: .orange, emoji: "🥹", schedule: [WeekDay.tuesday, WeekDay.friday]),
            ]
        ),
        TrackerCategory(
            title: "Сделать уроки",
            trackers: [
                Tracker(id: UUID(), title: "География", color: .green, emoji: "🏓", schedule: [WeekDay.friday, WeekDay.tuesday]),
                Tracker(id: UUID(), title: "Математика", color: .orange, emoji: "🥹", schedule: WeekDay.allCases),
            ]
        )
    ]
    
    private init() { }
}
