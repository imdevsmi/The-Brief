//
//  WeatherCardView.swift
//  The Brief
//
//  Created by Sami Gündoğan on 24.09.2025.
//

import SnapKit
import UIKit

final class WeatherCardView: UIView {
    
    // MARK: - Properties
    let searchBar = UISearchBar()
    private let iconImageView = UIImageView()
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let conditionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        
        searchBar.placeholder = L("search_city")
        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = false
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = .tertiarySystemBackground
        textField.textColor = .label
        textField.attributedPlaceholder = NSAttributedString(string: L("search_city"), attributes: [.foregroundColor: UIColor.secondaryLabel])
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.separator.cgColor
        
        cityLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        conditionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        tempLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        tempLabel.textColor = .label
        cityLabel.textColor = .label
        conditionLabel.textColor = .secondaryLabel
        
        let vStack = UIStackView(arrangedSubviews: [cityLabel, tempLabel, conditionLabel])
        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.alignment = .leading

        let hStack = UIStackView(arrangedSubviews: [iconImageView, vStack])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 12
        
        let mainStack = UIStackView(arrangedSubviews: [searchBar, hStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(16) }
        iconImageView.snp.makeConstraints { make in make.width.height.equalTo(60) }
    }
    
    func configure(with model: WeatherUIModel) {
        cityLabel.text = model.city
        tempLabel.text = model.temp
        conditionLabel.text = model.condition
        
        if let url = URL(string: model.iconURL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data else { return }
                DispatchQueue.main.async { self.iconImageView.image = UIImage(data: data) }
            }.resume()
        } else { iconImageView.image = nil }
    }
}
