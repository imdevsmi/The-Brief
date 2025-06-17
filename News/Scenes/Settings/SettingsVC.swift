//
//  SettingsVC.swift
//  News
//
//  Created by Sami Gündoğan on 20.05.2025.
//

import UIKit
import SnapKit

protocol SettingsVMOutputProtocol: AnyObject {
    func didTheme(_ mode: Int)
    func didUpdateNotification(_ isAuthorized: Bool)
    func openURL(_ url: String)
    func promptReview()
}

final class SettingsVC: UIViewController {
    
}
