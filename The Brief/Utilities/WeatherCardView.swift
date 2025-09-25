//
//  WeatherCardView.swift
//  The Brief
//
//  Created by Sami Gündoğan on 24.09.2025.
//

import SnapKit
import UIKit

final class WeatherCardView: UIView {
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .label
        return label
    }()
    
    private let rangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let aqiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()
    
    private let alertsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func SetupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        
        let vStack = UIStackView(arrangedSubviews: [cityLabel, tempLabel, rangeLabel, aqiLabel, alertsLabel])
        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.alignment = .leading
        
        let hStack = UIStackView(arrangedSubviews: [iconImageView, vStack])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 12
        
        addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
    }
    
    func configure(with model: WeatherUIModel) {
        cityLabel.text = "\(model.city) - \(model.condition)"
        tempLabel.text = model.temp
        rangeLabel.text = "En düşük \(model.min)°, En yüksek \(model.max)°"
    }
}
