//
//  SettingsVC.swift
//  News
//
//  Created by Sami Gündoğan on 20.05.2025.
//

import UIKit
import SafariServices
import SnapKit
import StoreKit

protocol SettingsVMOutputProtocol: AnyObject {
    func updateTheme(_ mode: Int)
    func updateNotification(_ isAuthorized: Bool)
    func openURL(_ url: String)
    func showReview()
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
        setupUI()
    }
}

// MARK: Private Methods
private extension SettingsVC {
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        setupConstraints()
        setupLayout()
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: Data Source- TableViewDelegate
extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .label
        
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = .label
        cell.textLabel?.textAlignment = .natural
        cell.imageView?.image = UIImage(systemName: item.iconName)
        
        switch item.type {
        case .theme:
            let segmentedControl = UISegmentedControl(items: ["Auto", "Light", "Dark"])
            segmentedControl.selectedSegmentIndex = viewModel.input?.themeMode() ?? 0
            segmentedControl.addTarget(self, action: #selector(didChangeTheme(_:)), for: .valueChanged)
            cell.accessoryView = segmentedControl
            
        case .notification:
            let switcher = UISwitch()
            viewModel.input?.fetchNotificationStatus { switcher.isOn = $0 }
            switcher.addTarget(self, action: #selector(didToggleNotification), for: .valueChanged)
            cell.accessoryView = switcher
            
        case .rateUs, .privacyPolicy, .termsOfUse:
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator
            
        case .version:
            cell.imageView?.image = nil
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .secondaryLabel
        }
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        viewModel.input?.didSelect(item: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

@objc private extension SettingsVC {
    func didChangeTheme(_ sender: UISegmentedControl) {
        viewModel.input?.updateThemeMode(sender.selectedSegmentIndex)
    }
    func didToggleNotification(_ sender: UISwitch) {
        viewModel.input?.updateNotification(isOn: sender.isOn)
    }
}

extension SettingsVC: SettingsVMOutputProtocol {
    func updateTheme(_ mode: Int) {
        switch mode {
        case 1: view.window?.overrideUserInterfaceStyle = .light
        case 2: view.window?.overrideUserInterfaceStyle = .dark
        default: view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func updateNotification(_ isAuthorized: Bool) {
        print("Notification \(isAuthorized ? "On" : "Off")")
    }
    
    func openURL(_ url: String) {
        guard let urlToOpen = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: urlToOpen)
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true)
    }
    
    func showReview() {
        if let scn = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scn)
        }
    }
}
