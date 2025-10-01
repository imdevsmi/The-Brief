//
//  SettingsVM.swift
//  The Brief
//
//  Created by Sami Gündoğan on 17.06.2025.
//

import Foundation
import UserNotifications

protocol SettingsVMInputProtocol: AnyObject {
    func themeMode() -> Int
    func updateThemeMode(_ mode: Int)
    func currentLanguageIndex() -> Int
    func currentLanguageName() -> String
    func setLanguage(_ lang: String)
    func didSelect(item: SettingsModel)
    func updateNotification(isOn: Bool)
    func fetchNotificationStatus(_ completion: @escaping (Bool) -> Void)
    func appVersion() -> String
}

final class SettingsVM {
    private let themeKey = "savedTheme"
    private let languageKey = "appLanguage"
    private let notificationKey = "userNotificationEnabled"

    weak var input: SettingsVMInputProtocol?
    weak var output: SettingsVMOutputProtocol?
    
    var isNotificationEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: notificationKey) }
        set { UserDefaults.standard.set(newValue, forKey: notificationKey) }
    }
    
    lazy var sections: [SettingsSection] = [
        SettingsSection(title: "Appearance", items: [SettingsModel(type: .theme), SettingsModel(type: .language)]),
        SettingsSection(title: "Notifications", items: [SettingsModel(type: .notification)]),
        SettingsSection(title: "General", items: [SettingsModel(type: .rateUs)]),
        SettingsSection(title: "Legal", items: [SettingsModel(type: .privacyPolicy),SettingsModel(type: .termsOfUse)]),
        SettingsSection(title: "About", items: [SettingsModel(type: .version)])
    ]
}

// MARK: - SettingsVMInputProtocol
extension SettingsVM: SettingsVMInputProtocol {
    func themeMode() -> Int { UserDefaults.standard.integer(forKey: themeKey) }
    
    func updateThemeMode(_ mode: Int) {
        UserDefaults.standard.set(mode, forKey: themeKey)
        output?.updateTheme(mode)
    }
    
    func currentLanguageIndex() -> Int {
        let lang = UserDefaults.standard.string(forKey: languageKey) ?? "en"
        return lang == "tr" ? 0 : 1
    }
    
    func currentLanguageName() -> String {
        let lang = UserDefaults.standard.string(forKey: languageKey) ?? "en"
        return lang == "tr" ? "Türkçe" : "English"
    }
    
    func setLanguage(_ lang: String) {
        UserDefaults.standard.set(lang, forKey: languageKey)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
    
    func didSelect(item: SettingsModel) {
        switch item.type {
        case .rateUs: output?.showReview()
        case .privacyPolicy: output?.openURL("https://www.linkedin.com/in/samigundogan/")
        case .termsOfUse: output?.openURL("https://www.linkedin.com/in/samigundogan/")
        default: break
        }
    }
    
    func updateNotification(isOn: Bool) {
        isNotificationEnabled = isOn
        
        guard isOn else {
            output?.updateNotification(false)
            return
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            DispatchQueue.main.async { self?.output?.updateNotification(granted) }
        }
    }
    
    func fetchNotificationStatus(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { status in
            let systemAuthorized = status.authorizationStatus == .authorized
            let switchState = self.isNotificationEnabled && systemAuthorized
            DispatchQueue.main.async { completion(switchState) }
        }
    }
    
    func appVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
        return "Version \(version) (\(build))"
    }
}
