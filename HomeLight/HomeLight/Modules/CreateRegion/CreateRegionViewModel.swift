//
//  CreateRegionViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 20.06.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

protocol CreateRegionViewModelType {
    var coordinator: CreateRegionCoordinator { get }

    func createRegion(_ name: String, _ groupsCount: Int, _ supportsAddress: Bool)
}

class CreateRegionViewModel: CreateRegionViewModelType {
    var ref: DatabaseReference!
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: CreateRegionCoordinator
    
    var regionsCount = 0
    
    let routing = Routing()
    
    struct Routing: CreateRegionRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
    }

    init(coordinator: CreateRegionCoordinator) {
        self.coordinator = coordinator
        
        ref = Database.database().reference()
        
        ref.child("regions").observe(.value, with: { snapshot in
            let decoder = JSONDecoder()
            
            if let value = snapshot.value, JSONSerialization.isValidJSONObject(value), let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
                if let decodedData = try? decoder.decode([RegionModel].self, from: data) {
                    self.regionsCount = decodedData.count
                }
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    func createRegion(_ name: String, _ groupsCount: Int, _ supportsAddress: Bool) {
        if let id = Auth.auth().currentUser?.uid {
            let region = [
                "groupsCount": groupsCount,
                "hasAddressSupport": supportsAddress,
                "name": name,
                "isProcessed": false
            ] as [String : Any]
            
            let childUpdates = ["/\(regionsCount)": region]
            ref.child("regions").updateChildValues(childUpdates)
            self.routing.close.send()
        }
    }
}

protocol CreateRegionRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
}

