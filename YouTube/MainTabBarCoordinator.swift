//
//  MainTabBarCoordinator.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

class MainTabBarCoordinator {

    weak var tabBarController: UITabBarController?

    func start() -> UIViewController {
        let tabBarController = UITabBarController()
        self.tabBarController = tabBarController
        tabBarController.viewControllers = [
            home(),
            subscriptions(),
            library(),
        ]
        return tabBarController
    }

    private func home() -> UIViewController {
        let viewController = HomeViewController()
        viewController.tabBarItem = .init(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return viewController
    }

    private func subscriptions() -> UIViewController {
        let controller = SubscriptionsViewController()
        controller.tabBarItem = .init(
            title: "Subscriptions",
            image: .init(systemName: "books.vertical"),
            selectedImage: .init(systemName: "books.vertical.fill")
        )
        return controller
    }

    private func library() -> UIViewController {
        let controller = LibraryViewController()
        controller.tabBarItem = .init(
            title: "Library",
            image: .init(systemName: "folder"),
            selectedImage: .init(systemName: "folder.fill")
        )
        return controller
    }
}

