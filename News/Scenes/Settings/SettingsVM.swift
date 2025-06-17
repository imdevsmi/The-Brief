//
//  SettingsVM.swift
//  News
//
//  Created by Sami Gündoğan on 17.06.2025.
//

import Foundation


protocol SettingsViewMInputProtocol: AnyObject {
    func fetchThemeMode() -> Int
    func updateThemeMode(_ mode: Int)
    
    func updateNotification(isOn: Bool)
    func fetchNotificationStatus(_ completion: @escaping (Bool) -> Void)
}

final class SettingsVM {
    
}
