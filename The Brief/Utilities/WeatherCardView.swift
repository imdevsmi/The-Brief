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
        
        if let aqi = model.airQualityIndex {
            aqiLabel.text = "Hava Kalitesi: \(aqi)"
            switch aqi {
            case 0...50: aqiLabel.textColor = .systemGreen
            case 51...100: aqiLabel.textColor = .systemYellow
            case 101...150: aqiLabel.textColor = .systemOrange
            case 151...200: aqiLabel.textColor = .systemRed
            case 201...300: aqiLabel.textColor = .purple
            default: aqiLabel.textColor = .brown
            }
        } else {
            aqiLabel.text = ""
        }
        
        if !model.alerts.isEmpty {
            alertsLabel.text = model.alerts
                .map { "\($0.severity.uppercased()): \($0.headline)" }
                .joined(separator: "\n")
            
            if let severity = model.alerts.first?.severity.lowercased() {
                switch severity {
                case "severe":
                    alertsLabel.textColor = .systemRed
                case "moderate":
                    alertsLabel.textColor = .systemOrange
                default:
                    alertsLabel.textColor = .systemYellow
                }
            }
        } else {
            alertsLabel.text = ""
        }
        
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
