//
//  SelectRegionCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import UIKit
import Combine

class SelectRegionCoordinator: Coordinator<Void> {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = SelectRegionViewModel(coordinator: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectRegionViewController") as! SelectRegionViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        viewModel.routing.goToFillAddress
            .flatMap { [weak self, weak router] placeModel -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: FillAddressCoordinator(router: router, placeModel: placeModel))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
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
        
        return viewModel.routing.close
            .handleEvents(receiveOutput: { [weak router, weak viewController] _ in
                guard let viewController = viewController else { return }
                router?.pop(viewController, true)
            })
            .eraseToAnyPublisher()
    }
}
