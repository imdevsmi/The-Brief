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
    //MARK: - Properties
    private let viewModel: PulseVM
    
    private lazy var weatherCard: WeatherCardView = {
        let card = WeatherCardView()
        card.searchBar.delegate = self
        
        return card
    }()
    
    private let weatherTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L("weather_title")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        
        return label
    }()
    
    init(viewModel: PulseVM = PulseVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadLastCity()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        view.addSubview(weatherTitleLabel)
        weatherTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(weatherCard)
        weatherCard.snp.makeConstraints { make in
            make.top.equalTo(weatherTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(140)
        }
    }
}

// MARK: - PulseVCOutputProtocol
extension PulseVC: PulseVCOutputProtocol {
    func didUpdateWeather(_ model: WeatherUIModel) { weatherCard.configure(with: model) }
}

// MARK: - UISearchBarDelegate
extension PulseVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text?.trimmingCharacters(in: .whitespaces), !city.isEmpty else { return }
        viewModel.fetchWeather(for: city)
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String) { }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { }
}
