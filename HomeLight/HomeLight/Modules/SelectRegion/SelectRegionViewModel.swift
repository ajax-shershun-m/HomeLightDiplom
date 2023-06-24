//
//  SelectRegionViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import Combine
import FirebaseAuth
import FirebaseDatabase


protocol SelectRegionViewModelType {
    var coordinator: SelectRegionCoordinator { get }
    
    var regions: [RegionModel] { get }
    
    func goToFillAddress(with region: RegionModel)
    var shouldReload: PassthroughSubject<Void, Never> { get }
}

class SelectRegionViewModel: SelectRegionViewModelType {

    var regions: [RegionModel] = []
    var ref: DatabaseReference!
    var shouldReload = PassthroughSubject<Void, Never>()
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: SelectRegionCoordinator
    
    let routing = Routing()
    
    struct Routing: SelectRegionRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
        var goToFillAddress = PassthroughSubject<PlaceModel, Never>()
        var goToSelectGroup = PassthroughSubject<(PlaceModel, Int), Never>()
    }

    init(coordinator: SelectRegionCoordinator) {
        self.coordinator = coordinator
        ref = Database.database().reference()
        fetchRegions()
    }
    
    func fetchRegions() {
        ref.child("regions").observe(.value, with: { snapshot in
            let decoder = JSONDecoder()
            
            if let value = snapshot.value, JSONSerialization.isValidJSONObject(value), let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
                if let decodedData = try? decoder.decode([RegionModel].self, from: data) {
                    self.regions = decodedData.filter({ $0.isProcessed })
                    self.shouldReload.send()
                }
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func goToFillAddress(with region: RegionModel) {
        if region.hasAddressSupport {
            routing.goToFillAddress.send(PlaceModel(city: region.name))
        } else {
            routing.goToSelectGroup.send((PlaceModel(city: region.name), region.groupsCount))
        }
    }
}

protocol SelectRegionRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
    var goToFillAddress: PassthroughSubject<PlaceModel, Never> { get }
    var goToSelectGroup: PassthroughSubject<(PlaceModel, Int), Never> { get }
}
