//
//  PulseVC.swift
//  The Brief
//
//  Created by Sami Gündoğan on 20.09.2025.
//

import SnapKit
import UIKit

protocol PulseVCOutputProtocol: AnyObject {
    func didUpdateWeather(_ model: WeatherUIModel)
}

final class PulseVC: UIViewController {
    
    private let viewModel: PulseVM
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Şehir girin..."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ara", for: .normal)
        button.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        return button
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
        
        view.addSubview(searchField)
        view.addSubview(searchButton)
        view.addSubview(weatherCard)
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(searchButton.snp.leading).offset(-8)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchField)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(60)
        }
        
        weatherCard.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func didTapSearch() {
        guard let city = searchField.text, !city.isEmpty else { return }
        viewModel.input?.fetchWeather(for: city)
    }
}

extension PulseVC: PulseVCOutputProtocol {
    func didUpdateWeather(_ model: WeatherUIModel) {
        weatherCard.configure(with: model)
    }
}
