//
//  ReportsHistoryViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 15.06.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

struct Report: Decodable {
    let id: String
    let text: String
    let date: String
    let image: URL
}

protocol ReportsHistoryViewModelType {
    var coordinator: ReportsHistoryCoordinator { get }

    var shouldReload: PassthroughSubject<Void, Never> { get }
    
    func goToReportDetails(id: Report)
    
    var reports: [Report] { get }
}

class ReportsHistoryViewModel: ReportsHistoryViewModelType {
    var ref: DatabaseReference!
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: ReportsHistoryCoordinator
    
    let routing = Routing()
    
    var reports: [Report] = []
    var shouldReload = PassthroughSubject<Void, Never>()
    
    struct Routing: ReportsHistoryRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
        var reportDetails = PassthroughSubject<Report, Never>()
    }

    init(coordinator: ReportsHistoryCoordinator) {
        self.coordinator = coordinator
        
        ref = Database.database().reference()
        
        fetchPlaces { [weak self] places in
            guard let self = self else { return }
            
            self.reports = places
            self.shouldReload.send()
        }
    }
    
    func goToReportDetails(id: Report) {
        self.routing.reportDetails.send(id)
    }
    
    func fetchPlaces(completion: @escaping ([Report]) -> Void) {
        if let id = Auth.auth().currentUser?.uid {
            ref.child("reports").child(id).observe(.value, with: { snapshot in
                let decoder = JSONDecoder()
                
                if let value = snapshot.value, JSONSerialization.isValidJSONObject(value),
                   let data = try? JSONSerialization.data(withJSONObject: value, options: []) {
                    if let decodedData = try? decoder.decode([String : Report].self, from: data) {
                        completion(decodedData.compactMap({ $0.value }))
                    }
                } else {
                    completion([])
                }
                
            }) { error in
                print(error.localizedDescription)
            }
        }
    }
}

protocol ReportsHistoryRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
    var reportDetails: PassthroughSubject<Report, Never> { get }
}

