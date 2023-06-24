//
//  SelectBuildingViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 18.06.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth

struct BuildingElement: Codable {
    let streetID: Int
    let name: String
    let group: Int

    enum CodingKeys: String, CodingKey {
        case streetID = "street_id"
        case name, group
    }
}

typealias Building = [BuildingElement]

protocol SelectBuildingViewModelType {
    var coordinator: SelectBuildingCoordinator { get }
    var street: StreetElement { get }
    var buildings: Building { get set }
    var filteredBuildings: Building { get set }
    var shouldReload: PassthroughSubject<Void, Never> { get }
    func goToCreatePlace(with building: BuildingElement)
    func loadJson(fromURLString urlString: String, completion: @escaping (Result<Building, Error>) -> Void)
}

class SelectBuildingViewModel: SelectBuildingViewModelType {
    var street: StreetElement
    
    var ref: DatabaseReference!
    var buildings: Building = []
    var filteredBuildings: Building = []
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: SelectBuildingCoordinator
    var shouldReload = PassthroughSubject<Void, Never>()
    let routing = Routing()
    
    struct Routing: SelectBuildingRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
        var goToCreatePlace = PassthroughSubject<PlaceModel, Never>()
    }

    init(coordinator: SelectBuildingCoordinator, street: StreetElement) {
        self.coordinator = coordinator
        self.street = street
        
        ref = Database.database().reference()
    }
    
    func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Building, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    let streets: Building = try! JSONDecoder().decode(Building.self, from: data)
                    completion(.success(streets))
                }
            }
            
            urlSession.resume()
        }
    }
    
    func goToCreatePlace(with building: BuildingElement) {
        routing.goToCreatePlace.send(PlaceModel(group: "\(building.group)", city: "м. Київ"))
    }
}

protocol SelectBuildingRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
    var goToCreatePlace: PassthroughSubject<PlaceModel, Never> { get }
}
