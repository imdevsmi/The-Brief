//
//  FinanceCardView.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import SnapKit
import UIKit

final class FinanceCardView: UIView {
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func SetupUI(){
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.borderWidth = 2
        layer.borderColor = UIColor.label.withAlphaComponent(0.25).cgColor
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with models: [FinanceUIModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for model in models {
            let itemView = createFinanceItemView(with: model)
            stackView.addArrangedSubview(itemView)
        }
    }
    
    private func createFinanceItemView(with model: FinanceUIModel) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .tertiarySystemBackground
        containerView.layer.cornerRadius = 8
        
        let pairLabel = UILabel()
        pairLabel.text = model.pair
        pairLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        pairLabel.textColor = .label
        
        let bidContainer = createValueContainer(title: L("buy_title"), value: model.bid, color: .systemGreen)
        let offerContainer = createValueContainer(title: L("sell_title"), value: model.offer, color: .systemRed)

        containerView.addSubview(pairLabel)
        containerView.addSubview(bidContainer)
        containerView.addSubview(offerContainer)
        
        pairLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        offerContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
        bidContainer.snp.makeConstraints { make in
            make.trailing.equalTo(offerContainer.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(70)
        }
        containerView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        return containerView
    }
    
    private func createValueContainer(title: String, value: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = color.withAlphaComponent(0.1)
        container.layer.cornerRadius = 6
        container.layer.borderWidth = 1
        container.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 10, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 14, weight: .bold)
        valueLabel.textColor = color
        valueLabel.textAlignment = .center
        
        container.addSubview(titleLabel)
        container.addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(4)
        }
        return container
    }
}
