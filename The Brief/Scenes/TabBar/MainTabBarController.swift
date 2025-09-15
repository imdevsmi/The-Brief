//
//  TabBar.swift
//  The Brief
//
//  Created by Sami Gündoğan on 20.05.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabs()
        observeNotifications()
    }
    
    // MARK: - Deinit
    deinit { NotificationCenter.default.removeObserver(self, name: .languageChanged, object: nil) }
}

// MARK: - Private Methods
private extension MainTabBarController {
    func setupTabs() {
        let homeVC = createNav(with: L("tab_home"), and: UIImage(systemName: "newspaper.fill"), viewController: HomeVC(viewModel: HomeVM()))
        let settingsVC = createNav(with: L("tab_settings"), and: UIImage(systemName: "gear"), viewController: SettingsVC())
        let favoritesVC = createNav(with: L("tab_favorites"), and: UIImage(systemName: "bookmark.fill"), viewController: FavoritesVC())
        
        setViewControllers([homeVC, favoritesVC, settingsVC], animated: false)
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurView, at: 0)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = blurEffect
        appearance.shadowColor = UIColor.systemGray4
        appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.05
        tabBar.layer.masksToBounds = false
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

    // MARK: - NotificationCenter
    func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = viewController as? UINavigationController,
           let homeVC = nav.viewControllers.first as? HomeVC { homeVC.scrollToTop() }
    }
}

// MARK: - Objective Methods
@objc private extension MainTabBarController {
    func languageDidChange() { setupTabs() }
}
