//
//  SettingsVM.swift
//  News
//
//  Created by Sami Gündoğan on 17.06.2025.
//

import Foundation
import UserNotifications

protocol SettingsVMInputProtocol: AnyObject {
    func fetchThemeMode() -> Int
    func updateThemeMode(_ mode: Int)
    func didSelect(item: SettingsModel)
    func updateNotification(isOn: Bool)
    func fetchNotificationStatus(_ completion: @escaping (Bool) -> Void)
}

final class SettingsVM {
    private let themeKey = "savedTheme"
    
    weak var input: SettingsVMInputProtocol?
    weak var output: SettingsVMOutputProtocol?
    
    lazy var sections: [SettingsSection] = [
        SettingsSection(title: "Appearance", items: [SettingsModel(title: "App Theme", iconName: "circle.righthalf.filled", type: .theme)]),
        
        SettingsSection(title: "Notifications", items: [SettingsModel(title: "Notifications", iconName: "bell.fill", type: .notification)]),
        
        SettingsSection(title: "General", items: [SettingsModel(title: "Rate us", iconName: "star.fill", type: .rateApp)]),
        
        SettingsSection(title: "Legal", items: [SettingsModel(title: "Privacy Policy", iconName: "text.document.fill", type: .privacyPolicy), SettingsModel(title: "Terms of Use", iconName:"checkmark.shield.fill", type: .termsOfUse)])
    ]
}

extension SettingsVM: SettingsVMInputProtocol {
    func fetchThemeMode() -> Int {
        UserDefaults.standard.integer(forKey: themeKey)
    }
    
    func updateThemeMode(_ mode: Int) {
        UserDefaults.standard.set(mode, forKey: themeKey)
        output?.didTheme(mode)
    }
    
    func didSelect(item: SettingsModel) {
        switch item.type {
        case .rateApp: output?.promptReview()
        case .privacyPolicy: output?.openURL("")
        case .termsOfUse: output?.openURL("")
        default: break
        }
    }
    
    func updateNotification(isOn: Bool) {
        guard isOn else {
            output?.didUpdateNotification(false)
            return
        }
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: options) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.output?.didUpdateNotification(granted)
            }
        }
    }
    
    func fetchNotificationStatus(_ completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            let isAuthorized = settings.authorizationStatus == .authorized
            
            DispatchQueue.main.async {
                completion(isAuthorized)
            }
        }
    }
}
