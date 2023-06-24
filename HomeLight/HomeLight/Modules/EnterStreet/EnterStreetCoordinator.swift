//
//  EnterStreetCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 10.05.2023.
//

import UIKit
import Combine

class EnterStreetCoordinator: Coordinator<Void> {
    private let router: Router
    private let placeModel: PlaceModel

    init(router: Router, placeModel: PlaceModel) {
        self.router = router
        self.placeModel = placeModel
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = EnterStreetViewModel(coordinator: self, placeModel: placeModel)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EnterStreetViewController") as! EnterStreetViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        viewModel.routing.goToEnterBuilding
            .flatMap { [weak self, weak router] id -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: SelectBuildingCoordinator(router: router, street: id))
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

