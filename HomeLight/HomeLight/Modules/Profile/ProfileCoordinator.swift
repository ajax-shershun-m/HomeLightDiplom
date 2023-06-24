//
//  ProfileCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 27.04.2023.
//

import UIKit
import Combine

class ProfileCoordinator: Coordinator<Void> {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = ProfileViewModel(coordinator: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        viewModel.routing.goToCreateReport
            .flatMap { [weak self, weak router] _ -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: CreateReportCoordinator(router: router))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
        viewModel.routing.goToReportsHistory
            .flatMap { [weak self, weak router] _ -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: ReportsHistoryCoordinator(router: router))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
        viewModel.routing.goToCreateRegion
            .flatMap { [weak self, weak router] _ -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: CreateRegionCoordinator(router: router))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
        return viewModel.routing.close
            .handleEvents(receiveOutput: { [weak router, weak viewController] _ in
                guard let viewController = viewController else { return }
                router?.pop(viewController, true)
            })
            .eraseToAnyPublisher()
    }
}

