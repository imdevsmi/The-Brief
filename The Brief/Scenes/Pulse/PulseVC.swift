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
    func didUpdateFinance(_ models: [FinanceUIModel])
}

final class PulseVC: UIViewController {
    //MARK: - Properties
    private let viewModel: PulseVM
    private let financeCard = FinanceCardView()
    private let weatherCard = WeatherCardView()
    
    private let weatherTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L("weather_title")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        
        return view
    }()
    
    private let financeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = L("finance_title")
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
        
        view.addSubview(financeCard)
        view.addSubview(financeTitleLabel)
        view.addSubview(separatorView)
        view.addSubview(weatherCard)
        view.addSubview(weatherTitleLabel)
        weatherCard.searchBar.delegate = self
        
        weatherTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        weatherCard.snp.makeConstraints { make in
            make.top.equalTo(weatherTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(weatherCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(5)
        }
        financeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        financeCard.snp.makeConstraints { make in
            make.top.equalTo(financeTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
    }
}

// MARK: - PulseVCOutputProtocol
extension PulseVC: PulseVCOutputProtocol {
    func didUpdateWeather(_ model: WeatherUIModel) { weatherCard.configure(with: model) }
    func didUpdateFinance(_ models: [FinanceUIModel]) { financeCard.configure(with: models) }
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
