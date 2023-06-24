//
//  ReportDetailsViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 17.06.2023.
//

import Combine
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore

protocol ReportDetailsViewModelType {
    var coordinator: ReportDetailsCoordinator { get }

    var shouldReload: PassthroughSubject<Void, Never> { get }
    
    var report: Report { get }
}

class ReportDetailsViewModel: ReportDetailsViewModelType {
    
    
    var ref: DatabaseReference!
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: ReportDetailsCoordinator
    
    let routing = Routing()
    
    var report: Report
    var shouldReload = PassthroughSubject<Void, Never>()
    
    struct Routing: ReportDetailsRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
    }

    init(coordinator: ReportDetailsCoordinator, report: Report) {
        self.coordinator = coordinator
        
        ref = Database.database().reference()
        self.report = report
    }
}

protocol ReportDetailsRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
}
