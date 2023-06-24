//
//  CreatePlaceCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 01.05.2023.
//

import UIKit
import Combine

class CreatePlaceCoordinator: Coordinator<Void> {
    private let router: Router
    private let placeModel: PlaceModel

    init(router: Router, placeModel: PlaceModel) {
        self.router = router
        self.placeModel = placeModel
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = CreatePlaceViewModel(coordinator: self, placeModel: placeModel)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreatePlaceViewController") as! CreatePlaceViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        return viewModel.routing.close
            .handleEvents(receiveOutput: { [weak router] _ in
                router?.popToRoot(true)
            })
            .eraseToAnyPublisher()
    }
}
