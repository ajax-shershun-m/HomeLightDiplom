//
//  PlaceModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 03.05.2023.
//

import Foundation

struct Place: Codable {
    var key: String
    var model: PlaceModel
}

struct PlaceModel: Codable {
    var id: String
    var name: String
    var group: String
    var city: String
    
    init(id: String = "", name: String = "", group: String = "", city: String = "") {
        self.id = id
        self.name = name
        self.group = group
        self.city = city
    }
}
