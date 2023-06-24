//
//  RegionModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.05.2023.
//

import Foundation

struct RegionModel: Codable {
    var groupsCount: Int
    var hasAddressSupport: Bool
    var isProcessed: Bool
    var name: String
}
