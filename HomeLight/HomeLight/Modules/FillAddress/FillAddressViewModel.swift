//
//  FillAddressViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import Combine

protocol FillAddressViewModelType {
    var coordinator: FillAddressCoordinator { get }
    
    var dataToFill: [FillAddressType] { get }
    var placeModel: PlaceModel { get }
    
    func goToSelectGroup()
    func goToSelectAddress()
}

class FillAddressViewModel: FillAddressViewModelType {

    var dataToFill = FillAddressType.allCases
    
    // MARK: - Inputs
    var placeModel: PlaceModel
    
    // MARK: - Outputs
    var coordinator: FillAddressCoordinator
    
    let routing = Routing()
    
    struct Routing: FillAddressRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
        var goToSelectGroup = PassthroughSubject<(PlaceModel, Int), Never>()
        var goToSelectAddress = PassthroughSubject<PlaceModel, Never>()
    }

    init(coordinator: FillAddressCoordinator, placeModel: PlaceModel) {
        self.coordinator = coordinator
        self.placeModel = placeModel
    }
    
    func goToSelectGroup() {
        routing.goToSelectGroup.send((placeModel, 3))
    }
    
    func goToSelectAddress() {
        routing.goToSelectAddress.send(placeModel)
    }
}

protocol FillAddressRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
    var goToSelectGroup: PassthroughSubject<(PlaceModel, Int), Never> { get }
    var goToSelectAddress: PassthroughSubject<PlaceModel, Never> { get }
}

enum FillAddressType: CaseIterable {
    case address, group
    
    var title: String {
        switch self {
        case .address:
            return "Ввести адресу"
        case .group:
            return "Вибрати групу"
        }
    }
}
