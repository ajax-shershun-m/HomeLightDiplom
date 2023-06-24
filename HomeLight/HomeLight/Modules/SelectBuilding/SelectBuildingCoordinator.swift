//
//  SelectBuildingCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 18.06.2023.
//

import UIKit
import Combine

class SelectBuildingCoordinator: Coordinator<Void> {
    private let router: Router
    private let street: StreetElement

    init(router: Router, street: StreetElement) {
        self.router = router
        self.street = street
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = SelectBuildingViewModel(coordinator: self, street: street)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectBuildingViewController") as! SelectBuildingViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        viewModel.routing.goToCreatePlace
            .flatMap { [weak self, weak router] placeModel -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: CreatePlaceCoordinator(router: router, placeModel: placeModel))
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

