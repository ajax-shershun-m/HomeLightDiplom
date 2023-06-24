//
//  SelectGroupViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import Combine

protocol SelectGroupViewModelType {
    var coordinator: SelectGroupCoordinator { get }
    
    var dataToFill: [String] { get }
    var placeModel: PlaceModel { get }
    
    func goToCreatePlace(with title: String)
}

class SelectGroupViewModel: SelectGroupViewModelType {

    var dataToFill: [String] = []
    
    // MARK: - Inputs
    var placeModel: PlaceModel
    var regionsCount: Int
    
    // MARK: - Outputs
    var coordinator: SelectGroupCoordinator
    
    let routing = Routing()
    
    struct Routing: SelectGroupRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
        var goToCreatePlace = PassthroughSubject<PlaceModel, Never>()
    }

    init(coordinator: SelectGroupCoordinator, placeModel: PlaceModel, regionsCount: Int) {
        self.coordinator = coordinator
        self.placeModel = placeModel
        self.regionsCount = regionsCount
        
        for i in 1...regionsCount {
            dataToFill.append("\(i)")
        }
    }
    
    func goToCreatePlace(with title: String) {
        placeModel.group = title
        routing.goToCreatePlace.send(placeModel)
    }
}

protocol SelectGroupRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
    var goToCreatePlace: PassthroughSubject<PlaceModel, Never> { get }
}
