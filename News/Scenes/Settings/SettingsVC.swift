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
        self.viewModel.input = self.viewModel
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
        title = NSLocalizedString("tab_settings", comment: "Ayarlar")
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.tintColor = .label
        cell.accessoryView = nil
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .natural
        cell.imageView?.image = nil
        
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = .label
        cell.textLabel?.textAlignment = .natural
        cell.imageView?.image = UIImage(systemName: item.iconName)
        
        switch item.type {
        case .theme:
            cell.textLabel?.text = L("theme_title")
            let segmentedControl = UISegmentedControl(items: [L("theme_auto"), L("theme_light"), L("theme_dark")])
            segmentedControl.selectedSegmentIndex = viewModel.input?.themeMode() ?? 0
            segmentedControl.addTarget(self, action: #selector(didChangeTheme(_:)), for: .valueChanged)
            cell.accessoryView = segmentedControl
            cell.selectionStyle = .none
            
        case .language:
            cell.textLabel?.text = L("language_title")
            cell.detailTextLabel?.text = viewModel.input?.currentLanguageName()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
        case .notification:
            cell.textLabel?.text = L("notification_title")
            let switcher = UISwitch()
            viewModel.input?.fetchNotificationStatus { switcher.isOn = $0 }
            switcher.addTarget(self, action: #selector(didToggleNotification), for: .valueChanged)
            cell.accessoryView = switcher
            cell.selectionStyle = .none
            
        case .rateUs:
            cell.textLabel?.text = L("rate_us_title")
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
        case .privacyPolicy:
            cell.textLabel?.text = L("privacy_policy_title")
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
        case .termsOfUse:
            cell.textLabel?.text = L("terms_of_use_title")
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
        case .version:
            cell.textLabel?.text = L("version_title")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .secondaryLabel
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
            cell.accessoryView = nil
        }
        
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        
        switch item.type {
        case .language:
            toggleLanguage()
            
        default:
            viewModel.input?.didSelect(item: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension SettingsVC {
    func toggleLanguage() {
        let currentIndex = viewModel.input?.currentLanguageIndex() ?? 0
        let newLang = currentIndex == 0 ? "en" : "tr"
        viewModel.input?.setLanguage(newLang)
        UserDefaults.standard.set(newLang, forKey: "appLanguage")
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        tableView.reloadData()
    }
}

@objc private extension SettingsVC {
    func didChangeTheme(_ sender: UISegmentedControl) {
        viewModel.input?.updateThemeMode(sender.selectedSegmentIndex)
    }
    
    func didToggleNotification(_ sender: UISwitch) {
        viewModel.input?.updateNotification(isOn: sender.isOn)
    }
    
    func languageDidChange() {
        tableView.reloadData()
    }
}

extension SettingsVC: SettingsVMOutputProtocol {
    func updateTheme(_ mode: Int) {
        DispatchQueue.main.async { [weak self] in
            let window = self?.view.window ?? UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
            
            guard let window = window else { return }
            switch mode {
            case 1: window.overrideUserInterfaceStyle = .light
            case 2: window.overrideUserInterfaceStyle = .dark
            default: window.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
    
    func updateNotification(_ isAuthorized: Bool) {
        
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
