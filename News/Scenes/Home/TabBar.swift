//
//  TabBar.swift
//  News
//
//  Created by Sami Gündoğan on 20.05.2025.
//

import UIKit

final class TabBar: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
}

// MARK: - Private Methods

private extension TabBar {
    func setupTabs() {
        let homeVC = createNav(with: "News", and: UIImage(systemName: "newspaper.fill"), viewController: HomeVC(viewModel: HomeVM()))
        let settingsVC = createNav(with: "Settings", and: UIImage(systemName: "gear"), viewController: SettingsVC())
        
        setViewControllers([homeVC, settingsVC], animated: false)
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }

    func createNav(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.title = title
        
        return nav
    }
}
