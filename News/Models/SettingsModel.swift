//
//  SettingsModel.swift
//  News
//
//  Created by Sami Gündoğan on 18.06.2025.
//

import Foundation

enum SettingsType {
    case theme
    case notification
    case rateApp
    case privacyPolicy
    case termsOfUse
    case version
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
