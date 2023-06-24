//
//  Coordinator.swift
//  HomeLight
//
//  Created by Maksim Shershun on 19.04.2023.
//

import UIKit
import Combine

protocol CoordinatorStorable: AnyObject {
    var childCoordinators: [UUID: Any] { get set }
    func store<T>(coordinator: Coordinator<T>)
    func free<T>(coordinator: Coordinator<T>)
}

class Coordinator<ResultType>: NSObject, CoordinatorStorable {
    var presentedViewController: UIViewController!
    var childCoordinators = [UUID: Any]()
    let identifier = UUID()
    var subscriptions = Set<AnyCancellable>()

    func store<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    func free<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    func coordinate<T>(to coordinator: Coordinator<T>) -> AnyPublisher<T, Never> {
        store(coordinator: coordinator)
        return coordinator.start()
            .handleEvents(receiveOutput: { [weak self, weak coordinator] _ in
                guard let coordinator = coordinator else { return }
                self?.free(coordinator: coordinator)
            })
            .eraseToAnyPublisher()
    }

    func start() -> AnyPublisher<ResultType, Never> {
        fatalError()
    }

    deinit {
        print("\(self) deinit")
    }
}
