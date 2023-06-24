//
//  PlaceDetailsViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 06.05.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth

protocol PlaceDetailsViewModelType {
    var coordinator: PlaceDetailsCoordinator { get }
    var placeModel: PlaceModel { get }
    var currentSelectedDayIndex: Int { get set }
    
    var data: [LightMissingModel] { get }
    
    func deletePlace()
}

class PlaceDetailsViewModel: PlaceDetailsViewModelType {
    var placeModel: PlaceModel
    private var placeKey: String
    var data: [LightMissingModel] = []
    var currentSelectedDayIndex = 0
    
    var ref: DatabaseReference!
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: PlaceDetailsCoordinator
    
    let routing = Routing()
    
    struct Routing: PlaceDetailsRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
    }

    init(coordinator: PlaceDetailsCoordinator, placeModel: PlaceModel, placeKey: String) {
        self.coordinator = coordinator
        self.placeModel = placeModel
        self.placeKey = placeKey
        getData()
        ref = Database.database().reference()
    }
    
    func deletePlace() {
        if let id = Auth.auth().currentUser?.uid {
            let ref = ref.child(id).child("places").child(placeKey)
            ref.removeValue { [weak self] error, ref in
                self?.routing.close.send()
            }
        } else {
            let ref = ref.child("places").child(placeKey)
            ref.removeValue { [weak self] error, ref in
                self?.routing.close.send()
            }
        }
    }
    
    func getData() {
        var region = ""
        if placeModel.city == "м. Київ" {
            region = "kyiv"
        } else if placeModel.city == "Київська обл." {
            region = "kyivRegion"
        } else if placeModel.city == "Одеська обл." {
            region = "odesaRegion"
        }
        if let path = Bundle.main.path(forResource: region, ofType: "json") {
            if let jsonData = NSData(contentsOfFile: path) as? Data {
                let decoder = JSONDecoder()
                
                if let data = try? decoder.decode([LightMissingModel].self, from: jsonData) {
                    print(data)
                    self.data = data
                }
                
            }
        }
    }
}

protocol PlaceDetailsRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
}
