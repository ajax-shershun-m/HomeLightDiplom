//
//  ProfileViewModel.swift
//  HomeLight
//
//  Created by Maksim Shershun on 27.04.2023.
//

import Combine
import FirebaseAuth

protocol ProfileViewModelType {
    var coordinator: ProfileCoordinator { get }
    
    func signOut()
    func goToCreateReport()
    func goToReportsHistory()
    func goToCreateRegion()
}

class ProfileViewModel: ProfileViewModelType {
    
    // MARK: - Inputs

    // MARK: - Outputs
    var coordinator: ProfileCoordinator
    
    let routing = Routing()
    
    struct Routing: ProfileRoutingProtocol {
        var close = PassthroughSubject<Void, Never>()
        var goToCreateReport = PassthroughSubject<Void, Never>()
        var goToReportsHistory = PassthroughSubject<Void, Never>()
        var goToCreateRegion = PassthroughSubject<Void, Never>()
    }

    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.routing.close.send()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func goToCreateReport() {
        self.routing.goToCreateReport.send()
    }
    
    func goToReportsHistory() {
        self.routing.goToReportsHistory.send()
    }
    
    func goToCreateRegion() {
        self.routing.goToCreateRegion.send()
    }
}

protocol ProfileRoutingProtocol {
    var close: PassthroughSubject<Void, Never> { get }
    var goToCreateReport: PassthroughSubject<Void, Never> { get }
    var goToReportsHistory: PassthroughSubject<Void, Never> { get }
    var goToCreateRegion: PassthroughSubject<Void, Never> { get }
}
