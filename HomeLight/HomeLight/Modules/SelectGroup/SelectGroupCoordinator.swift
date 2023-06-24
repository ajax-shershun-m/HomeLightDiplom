//
//  SelectGroupCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import UIKit
import Combine

class SelectGroupCoordinator: Coordinator<Void> {
    private let router: Router
    private let placeModel: PlaceModel
    private let regionsCount: Int

    init(router: Router, placeModel: PlaceModel, regionsCount: Int) {
        self.router = router
        self.placeModel = placeModel
        self.regionsCount = regionsCount
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = SelectGroupViewModel(coordinator: self, placeModel: placeModel, regionsCount: regionsCount)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectGroupViewController") as! SelectGroupViewController
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
