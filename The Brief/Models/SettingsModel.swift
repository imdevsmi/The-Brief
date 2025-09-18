//
//  SettingsModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 18.06.2025.
//

import Foundation

enum SettingsType {
    case theme, language, notification, rateUs, privacyPolicy, termsOfUse
    
    var titleKey: String {
        switch self {
        case .theme: return "theme_title"
        case .language: return "language_title"
        case .notification: return "notification_title"
        case .rateUs: return "rate_us_title"
        case .privacyPolicy: return "privacy_policy_title"
        case .termsOfUse: return "terms_of_use_title"
        }
    }
    
    var iconName: String {
        switch self {
        case .theme: return "moon.fill"
        case .language: return "globe"
        case .notification: return "bell.fill"
        case .rateUs: return "star.fill"
        case .privacyPolicy: return "lock.fill"
        case .termsOfUse: return "doc.text.fill"
        }
    }
    
    var isCustom: Bool {
        switch self {
        case .theme, .notification: return true
        default: return false
        }
    }
}

struct SettingsModel {
    let type: SettingsType
    var title: String { return L(type.titleKey) }
    var iconName: String { return type.iconName }
}

struct SettingsSection {
    let title: String
    let items: [SettingsModel]
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
