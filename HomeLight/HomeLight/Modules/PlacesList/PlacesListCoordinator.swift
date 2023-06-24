//
//  PlacesListCoordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import UIKit
import Combine

class PlacesListCoordinator: Coordinator<Void> {
    private let window: UIWindow!
    private var router: Router!
    private var navigationController: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> AnyPublisher<Void, Never> {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlacesListViewController") as! PlacesListViewController
        let viewModel = PlacesListViewModel(coordinator: self)
        viewController.viewModel = viewModel
        
        self.navigationController = UINavigationController(rootViewController: viewController)
        presentedViewController = navigationController
        
        router = Router(navigationController: navigationController)
        
        viewModel.routing.selectRegion
            .flatMap { [weak self, weak router] _ -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: SelectRegionCoordinator(router: router))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
        viewModel.routing.profile
            .flatMap { [weak self, weak router] _ -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: ProfileCoordinator(router: router))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
        viewModel.routing.goToPlaceDetails
            .flatMap { [weak self, weak router] (placeModel, placeKey) -> AnyPublisher<Void, Never> in
                guard
                    let self = self,
                    let router = router
                else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                
                return self.coordinate(to: PlaceDetailsCoordinator(router: router, placeModel: placeModel, placeKey: placeKey))
            }
            .sink(receiveValue: {})
            .store(in: &subscriptions)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}
