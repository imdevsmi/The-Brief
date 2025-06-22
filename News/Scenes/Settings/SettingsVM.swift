//
//  SettingsVM.swift
//  News
//
//  Created by Sami Gündoğan on 17.06.2025.
//

import Foundation

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
    
    init(){
        input = self
    }
    
    lazy var sections: [SettingsSection] = [
        SettingsSection(title: "Appearance", items: [SettingsModel(title: "App Theme", iconName: "circle.righthalf.filled", type: .theme)]),
        
        SettingsSection(title: "Notifications", items: [SettingsModel(title: "Notifications", iconName: "bell.fill", type: .notification)]),
        
        SettingsSection(title: "General", items: [SettingsModel(title: "Rate us", iconName: "star.fill", type: .rateApp)]),
        
        SettingsSection(title: "Legal", items: [SettingsModel(title: "Privacy Policy", iconName: "text.document.fill", type: .privacyPolicy), SettingsModel(title: "Terms of Use", iconName:"checkmark.shield.fill", type: .termsOfUse)])
    ]
    
}
