//
//  WeatherCardView.swift
//  The Brief
//
//  Created by Sami Gündoğan on 24.09.2025.
//

import SnapKit
import UIKit

final class WeatherCardView: UIView {
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
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)

        let vStack = UIStackView(arrangedSubviews: [cityLabel, tempLabel])
        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.alignment = .leading

        let hStack = UIStackView(arrangedSubviews: [iconImageView, vStack])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 12

        addSubview(hStack)
        hStack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(16) }
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
        } else {
            iconImageView.image = nil
        }
    }
}
