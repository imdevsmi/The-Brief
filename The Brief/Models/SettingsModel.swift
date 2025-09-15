//
//  SettingsModel.swift
//  The Brief
//
//  Created by Sami Gündoğan on 18.06.2025.
//

import Foundation

enum SettingsType {
    case theme
    case language
    case notification
    case rateUs
    case privacyPolicy
    case termsOfUse
}

struct SettingsModel {
    let title: String
    let iconName: String
    let type: SettingsType
}

struct SettingsSection {
    let title: String
    let items: [SettingsModel]
}
