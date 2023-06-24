//
//  PlacesListViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import Combine
import FirebaseAuth
import FirebaseDatabase

protocol PlacesListViewModelType {
    var coordinator: PlacesListCoordinator { get }
    
    var places: [PlaceModel] { get }
    
    var shouldReload: PassthroughSubject<Void, Never> { get }
    
    func goToSelectRegion()
    func goToProfile()
    func goToPlaceDetails(_ placeModel: PlaceModel)
    
    func reloadPlaces()
}

class PlacesListViewModel: PlacesListViewModelType {
    private var placesDict: [String : PlaceModel] = [:]
    
    var ref: DatabaseReference!
    var places: [PlaceModel] = []
    
    var shouldReload = PassthroughSubject<Void, Never>()
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: PlacesListCoordinator
    
    let routing = Routing()
    
    struct Routing: PlacesListRoutingProtocol {
        var selectRegion = PassthroughSubject<Void, Never>()
        var profile = PassthroughSubject<Void, Never>()
        var goToPlaceDetails = PassthroughSubject<(PlaceModel, String), Never>()
    }

    init(coordinator: PlacesListCoordinator) {
        self.coordinator = coordinator
        ref = Database.database().reference()
        
        fetchPlaces { [weak self] places in
            guard let self = self else { return }
            
            self.places = places
            self.shouldReload.send()
        }
    }
    
    func reloadPlaces() {
        fetchPlaces { [weak self] places in
            guard let self = self else { return }
            
            self.places = places
            self.shouldReload.send()
        }
    }
    
    func fetchPlaces(completion: @escaping ([PlaceModel]) -> Void) {
        if let id = Auth.auth().currentUser?.uid {
            ref.child(id).child("places").observe(.value, with: { snapshot in
                let decoder = JSONDecoder()
                
                if let value = snapshot.value, JSONSerialization.isValidJSONObject(value), let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
                    if let decodedData = try? decoder.decode([String : PlaceModel].self, from: data) {
                        self.placesDict = decodedData
                        completion(decodedData.compactMap({ $0.value }))
                    }
                } else {
                    completion([])
                }
                
            }) { error in
                print(error.localizedDescription)
            }
        } else {
            ref.child("places").observe(.value, with: { snapshot in
                let decoder = JSONDecoder()
                
                if let value = snapshot.value, JSONSerialization.isValidJSONObject(value), let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
                    if let decodedData = try? decoder.decode([String : PlaceModel].self, from: data) {
                        self.placesDict = decodedData
                        completion(decodedData.compactMap({ $0.value }))
                    }
                }
                
            }) { error in
                print(error.localizedDescription)
            }
        }
    }
    
    func goToSelectRegion() {
        self.routing.selectRegion.send()
    }
    
    func goToProfile() {
        self.routing.profile.send()
    }
    
    func goToPlaceDetails(_ placeModel: PlaceModel) {
        let key = placesDict.first(where: { $0.value.id == placeModel.id })?.key ?? ""
        self.routing.goToPlaceDetails.send((placeModel, key))
    }
}

protocol PlacesListRoutingProtocol {
    var selectRegion: PassthroughSubject<Void, Never> { get }
    var goToPlaceDetails: PassthroughSubject<(PlaceModel, String), Never> { get }
    var profile: PassthroughSubject<Void, Never> { get }
}
