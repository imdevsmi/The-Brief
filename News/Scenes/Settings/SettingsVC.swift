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

    // MARK: Properties

    private let viewModel: SettingsVM
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    // MARK: Inits

    init(viewModel: SettingsVM = SettingsVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
// MARK: Data Source- TableViewDelegate
extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}

extension SettingsVC: UITableViewDelegate {
    
}

extension SettingsVC: SettingsVMOutputProtocol {
    func didTheme(_ mode: Int) {
        switch mode {
        case 1: view.window?.overrideUserInterfaceStyle = .light
        case 2: view.window?.overrideUserInterfaceStyle = .dark
        default: view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func didUpdateNotification(_ isAuthorized: Bool) {
        
    }
    
    func openURL(_ url: String) {
        
    }
    
    func promptReview() {
        
    }
}
