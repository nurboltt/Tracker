//
//  TableViewCellType.swift
//  Tracker
//
//  Created by Nurbol on 05.12.2024.
//

import Foundation

enum TableViewCellType {
    case category(String)
    case schedule(String)
    
    var title: String {
        switch self {
        case .category:
            return "Категория"
        case .schedule:
            return "Расписание"
        }
    }
    
    var description: String {
        switch self {
        case .category(let desc):
            return desc
        case .schedule(let desc):
            return desc
        }
    }
}
