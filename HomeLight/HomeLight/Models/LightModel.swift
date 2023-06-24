//
//  LightModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 18.05.2023.
//

import Foundation

struct LightMisModel: Codable {
    let start, end: Int
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case definiteOutage = "DEFINITE_OUTAGE"
    case possibleOutage = "POSSIBLE_OUTAGE"
}

typealias LightMissingModel = [[LightMisModel]]

enum Groups: Int {
    case first = 0, second, third, forth, fifth, six
    
    var title: String {
        switch self {
        case .first: return "1"
        case .second: return "2"
        case .third: return "3"
        case .forth: return "4"
        case .fifth: return "5"
        case .six: return "6"
        }
    }
}

enum WeekDays: Int {
    case monday = 0, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var title: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
}
