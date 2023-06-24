//
//  Router.swift
//  HomeLight
//
//  Created by Maksim Shershun on 21.04.2023.
//

import UIKit
import SwiftUI

typealias NavigationBackClosure = (() -> Void)

protocol RouterProtocol: NSObject {
    func push(_ viewController: UIViewController, isAnimated: Bool, shouldPop: Bool, onNavigateBack: NavigationBackClosure?)
    func pop(_ viewController: UIViewController, _ isAnimated: Bool)
}

class Router: NSObject, RouterProtocol {
    var navigationController: UINavigationController?
    private var closures: [String: NavigationBackClosure] = [:]
    private var shouldPops: [String: Bool] = [:]

    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        super.init()
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func push(_ viewController: UIViewController, isAnimated: Bool, shouldPop: Bool = true, onNavigateBack closure: NavigationBackClosure?) {
        if let closure = closure {
            closures[viewController.description] = closure
        }
        shouldPops[viewController.description] = shouldPop
        navigationController?.pushViewController(viewController, animated: isAnimated)
    }

    func pop(_ viewController: UIViewController, _ isAnimated: Bool) {
        guard navigationController?.topViewController === viewController, let previousController = navigationController?.popViewController(animated: isAnimated) else { return }
        closures.removeValue(forKey: previousController.description)
        shouldPops.removeValue(forKey: previousController.description)
    }

    func popToRoot(_ isAnimated: Bool) {
        guard let previousControllers = navigationController?.popToRootViewController(animated: isAnimated) else { return }

        previousControllers.forEach({
            closures.removeValue(forKey: $0.description)
            shouldPops.removeValue(forKey: $0.description)
        })
    }

    static func present(_ viewController: UIViewController, to toVC: UIViewController, animated: Bool = false, modalTransitionStyle: UIModalTransitionStyle = .crossDissolve, modalPresentationStyle: UIModalPresentationStyle = .overFullScreen) {
        viewController.modalTransitionStyle = modalTransitionStyle
        viewController.modalPresentationStyle = modalPresentationStyle
        toVC.present(viewController, animated: animated, completion: nil)
    }

    static func dismiss(_ viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: animated, completion: nil)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(previousController) else {
            return
        }
        executeClosure(previousController)
    }
}

extension Router: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if navigationController?.viewControllers.count == 1 {
            return false
        }

        if let topViewController = navigationController?.topViewController {
            return shouldPops[topViewController.description] ?? false
        } else {
            return false
        }
    }
}
