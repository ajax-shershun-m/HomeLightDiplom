//
//  CreateReportCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 22.05.2023.
//

import UIKit
import Combine

class CreateReportCoordinator: Coordinator<Void> {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = CreateReportViewModel(coordinator: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CreateReportViewController") as! CreateReportViewController
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


