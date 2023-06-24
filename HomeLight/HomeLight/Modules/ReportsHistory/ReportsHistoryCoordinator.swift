//
//  ReportsHistoryCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 15.06.2023.
//

import UIKit
import Combine

class ReportsHistoryCoordinator: Coordinator<Void> {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = ReportsHistoryViewModel(coordinator: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ReportsHistoryViewController") as! ReportsHistoryViewController
        viewController.viewModel = viewModel
        presentedViewController = viewController
        
        router.push(viewController, isAnimated: true, shouldPop: false) { }
        
        viewModel.routing.reportDetails
            .flatMap { [weak self, weak router] id -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: ReportDetailsCoordinator(router: router, report: id))
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


