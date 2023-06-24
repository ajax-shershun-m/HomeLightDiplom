//
//  EnterStreetViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 10.05.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth

struct StreetElement: Codable {
    let id: Int
    let name: String
}

typealias Street = [StreetElement]


protocol EnterStreetViewModelType {
    var coordinator: EnterStreetCoordinator { get }

    var streets: Street { get set }
    var filteredStreets: Street { get set }
    var shouldReload: PassthroughSubject<Void, Never> { get }
    
    func goToEnterBuilding(with: StreetElement)
}

class EnterStreetViewModel: EnterStreetViewModelType {
    private var placeModel: PlaceModel
    
    var ref: DatabaseReference!
    var streets: Street = []
    var filteredStreets: Street = []
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: EnterStreetCoordinator
    var shouldReload = PassthroughSubject<Void, Never>()
    let routing = Routing()
    
    struct Routing: EnterStreetRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
        var goToEnterBuilding = PassthroughSubject<StreetElement, Never>()
    }

    init(coordinator: EnterStreetCoordinator, placeModel: PlaceModel) {
        self.coordinator = coordinator
        self.placeModel = placeModel
        
        ref = Database.database().reference()
        
        loadJson(fromURLString: "https://yasno.com.ua/api/v1/electricity-outages-schedule/streets?region=kiev") { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                self?.streets = data
                self?.filteredStreets = data
                self?.shouldReload.send()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func goToEnterBuilding(with: StreetElement) {
        routing.goToEnterBuilding.send(with)
    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Street, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    let streets: Street = try! JSONDecoder().decode(Street.self, from: data)
                    completion(.success(streets))
                }
            }
            
            urlSession.resume()
        }
    }
}

protocol EnterStreetRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
    var goToEnterBuilding: PassthroughSubject<StreetElement, Never> { get }
}

