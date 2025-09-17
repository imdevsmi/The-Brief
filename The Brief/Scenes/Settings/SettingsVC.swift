//
//  SettingsVC.swift
//  The Brief
//
//  Created by Sami Gündoğan on 20.05.2025.
//

import GoogleMobileAds
import SafariServices
import SnapKit
import StoreKit
import UIKit

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
    
    private lazy var bannerView: BannerAdView = {
        let view = BannerAdView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Inits
    init(viewModel: SettingsVM = SettingsVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
        self.viewModel.input = self.viewModel
        
        viewModel.input?.fetchNotificationStatus { [weak self] isAuthorized in
            self?.viewModel.isNotificationEnabled = isAuthorized
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeNotifications()
    }
    deinit { NotificationCenter.default.removeObserver(self, name: .languageChanged, object: nil) }
}

// MARK: - UI Setup
private extension SettingsVC {
    func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        setupConstraints()
        setupLayout()
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(bannerView)
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.bottom.equalTo(bannerView.snp.top)
        }
    }
    
    func bannerUI() {
        bannerView.snp.makeConstraints { make in
            make.bottom.equalTo(tabBarController?.tabBar.snp.top ?? view.safeAreaLayoutGuide.snp.bottom).offset(-4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}

// MARK: Data Source - TableViewDelegate
extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { viewModel.sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.sections[section].items.count }
    
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
        cell.imageView?.image = UIImage(systemName: item.iconName)
        
        switch item.type {
        case .theme:
            let segmentedControl = UISegmentedControl(items: [L("theme_auto"), L("theme_light"), L("theme_dark")])
            segmentedControl.selectedSegmentIndex = viewModel.input?.themeMode() ?? 0
            segmentedControl.addTarget(self, action: #selector(didChangeTheme(_:)), for: .valueChanged)
            cell.accessoryView = segmentedControl
            cell.selectionStyle = .none
            
        case .notification:
            let switcher = UISwitch()
            viewModel.input?.fetchNotificationStatus { isEnabled in
                switcher.isOn = isEnabled
            }
            switcher.addTarget(self, action: #selector(didToggleNotification), for: .valueChanged)
            cell.accessoryView = switcher
            cell.selectionStyle = .none
            
        case .language:
            cell.detailTextLabel?.text = viewModel.input?.currentLanguageName()
            fallthrough
            
        case .rateUs, .privacyPolicy, .termsOfUse:
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
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

// MARK: - Private Methods
private extension SettingsVC {
    func toggleLanguage() {
        let currentIndex = viewModel.input?.currentLanguageIndex() ?? 0
        let newLang = currentIndex == 0 ? "en" : "tr"
        viewModel.input?.setLanguage(newLang)
        UserDefaults.standard.set(newLang, forKey: "appLanguage")
        NotificationCenter.default.post(name: .languageChanged, object: nil)
        tableView.reloadData()
    }
    
    func observeNotifications() { NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil) }
}

// MARK: - SettingsVMOutputProtocol Conformance
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
    
    func updateNotification(_ isAuthorized: Bool) { }
    
    func openURL(_ url: String) {
        guard let urlToOpen = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: urlToOpen)
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true)
    }
    
    func showReview() { if let scn = view.window?.windowScene { SKStoreReviewController.requestReview(in: scn) } }
}

// MARK: - Objective Methods
@objc private extension SettingsVC {
    func didChangeTheme(_ sender: UISegmentedControl) { viewModel.input?.updateThemeMode(sender.selectedSegmentIndex) }
    
    func didToggleNotification(_ sender: UISwitch) {
        let isOn = sender.isOn
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) { sender.setOn(isOn, animated: true) }
        viewModel.isNotificationEnabled = isOn
        viewModel.input?.updateNotification(isOn: isOn)
        tableView.reloadData()
    }
    
    func languageDidChange() { tableView.reloadData() }
}
