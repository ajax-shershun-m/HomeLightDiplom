//
//  ReportDetailsCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 17.06.2023.
//

import UIKit
import Combine

class ReportDetailsCoordinator: Coordinator<Void> {
    private let router: Router
    private let report: Report

    init(router: Router, report: Report) {
        self.router = router
        self.report = report
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = ReportDetailsViewModel(coordinator: self, report: report)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ReportDetailsViewController") as! ReportDetailsViewController
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



