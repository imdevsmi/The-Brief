//
//  SceneDelegate.swift
//  News
//
//  Created by Sami Gündoğan on 18.05.2025.
//

import Kingfisher
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let themeKey = "savedTheme"
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window = window
        window.windowScene = windowScene
        let homeVC = HomeVC()
        let navigationController = UINavigationController(rootViewController: homeVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        applyTheme()
        KingfisherManager.shared.cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        KingfisherManager.shared.cache.memoryStorage.config.expiration = .seconds(300)
    }
    private func applyTheme() {
        let themeMode = UserDefaults.standard.integer(forKey: themeKey)
        switch themeMode {
        case 1:
            window?.overrideUserInterfaceStyle = .light
        case 2:
            window?.overrideUserInterfaceStyle = .dark
        default:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

