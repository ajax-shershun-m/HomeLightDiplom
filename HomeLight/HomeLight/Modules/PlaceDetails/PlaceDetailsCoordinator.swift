//
//  PlaceDetailsCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 06.05.2023.
//

import UIKit
import Combine

class PlaceDetailsCoordinator: Coordinator<Void> {
    private let router: Router
    private let placeModel: PlaceModel
    private let placeKey: String

    init(router: Router, placeModel: PlaceModel, placeKey: String) {
        self.router = router
        self.placeModel = placeModel
        self.placeKey = placeKey
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = PlaceDetailsViewModel(coordinator: self, placeModel: placeModel, placeKey: placeKey)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlaceDetailsViewController") as! PlaceDetailsViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        return viewModel.routing.close
            .handleEvents(receiveOutput: { [weak router, weak viewController] _ in
                guard let viewController = viewController else { return }
                router?.pop(viewController, true)
            })
            .eraseToAnyPublisher()
    }
}
