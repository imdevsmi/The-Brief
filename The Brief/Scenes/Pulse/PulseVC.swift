//
//  PulseVC.swift
//  The Brief
//
//  Created by Sami Gündoğan on 20.09.2025.
//

import UIKit
import SnapKit

protocol PulseVCOutputProtocol: AnyObject {
    func didUpdateWeather(_ model: WeatherUIModel)
}

final class PulseVC: UIViewController {
    
    private let viewModel: PulseVM
    
    // MARK: - UI Elements
    private lazy var searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.delegate = self
        sc.searchBar.placeholder = L("search_city")
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    private lazy var weatherCard: WeatherCardView = {
        let card = WeatherCardView()
        return card
    }()
    
    
    init(viewModel: PulseVM = PulseVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
        self.viewModel.input = self.viewModel
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
        view.addSubview(weatherCard)
        
        weatherCard.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - PulseVCOutputProtocol
extension PulseVC: PulseVCOutputProtocol {
    func didUpdateWeather(_ model: WeatherUIModel) {
        weatherCard.configure(with: model)
    }
}

// MARK: - UISearchBarDelegate
extension PulseVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text?.trimmingCharacters(in: .whitespaces), !city.isEmpty else { return }
        viewModel.input?.fetchWeather(for: city)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
        if text.isEmpty { }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
}
