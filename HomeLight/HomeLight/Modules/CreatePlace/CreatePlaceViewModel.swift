//
//  CreatePlaceViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth

protocol CreatePlaceViewModelType {
    var coordinator: CreatePlaceCoordinator { get }
    
    var dataToFill: [String] { get }
    var placeModel: PlaceModel { get }
    
    func close()
    func save(_ placeName: String)
}

class CreatePlaceViewModel: CreatePlaceViewModelType {

    var dataToFill = ["1", "2", "3"]
    var ref: DatabaseReference!
    
    // MARK: - Inputs
    var placeModel: PlaceModel
    
    // MARK: - Outputs
    var coordinator: CreatePlaceCoordinator
    
    let routing = Routing()
    
    struct Routing: CreatePlaceRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
    }

    init(coordinator: CreatePlaceCoordinator, placeModel: PlaceModel) {
        self.coordinator = coordinator
        self.placeModel = placeModel
        
        ref = Database.database().reference()
    }
    
    func close() {
        routing.close.send()
    }
    
    func save(_ placeName: String) {
        if let id = Auth.auth().currentUser?.uid {
            guard let key = ref.child(id).child("places").childByAutoId().key else { return }
            let place = [
                "id": UUID().uuidString,
                "city": placeModel.city,
                "group": placeModel.group,
                "name": placeName]
            let childUpdates = ["/places/\(key)": place]
            ref.child(id).updateChildValues(childUpdates)
        } else {
            guard let key = ref.child("places").childByAutoId().key else { return }
            let place = [
                "id": UUID().uuidString,
                "city": placeModel.city,
                "group": placeModel.group,
                "name": placeName]
            let childUpdates = ["/places/\(key)": place]
            ref.updateChildValues(childUpdates)
        }
        routing.close.send()
    }
}

protocol CreatePlaceRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
}
