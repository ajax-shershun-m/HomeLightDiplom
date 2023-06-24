//
//  CreateRegionCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 20.06.2023.
//

import UIKit
import Combine

class CreateRegionCoordinator: Coordinator<Void> {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = CreateRegionViewModel(coordinator: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateRegionViewController") as! CreateRegionViewController
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



