//
//  FillAddressCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import UIKit
import Combine

class FillAddressCoordinator: Coordinator<Void> {
    private let router: Router
    private let placeModel: PlaceModel

    init(router: Router, placeModel: PlaceModel) {
        self.router = router
        self.placeModel = placeModel
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = FillAddressViewModel(coordinator: self, placeModel: placeModel)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "FillAddressViewController") as! FillAddressViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        viewModel.routing.goToSelectGroup
            .flatMap { [weak self, weak router] (placeModel, regionsCount) -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: SelectGroupCoordinator(router: router, placeModel: placeModel, regionsCount: regionsCount))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
        viewModel.routing.goToSelectAddress
            .flatMap { [weak self, weak router] regionTitle -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: EnterStreetCoordinator(router: router, placeModel: placeModel))
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

