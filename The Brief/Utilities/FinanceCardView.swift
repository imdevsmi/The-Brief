//
//  FinanceCardView.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import SnapKit
import UIKit

final class FinanceCardView: UIView {
    // MARK: - Properties
    private let stackView = UIStackView()
    
    private lazy var segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [L("currencies_title"), L("metals_title")])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .clear
        sc.selectedSegmentTintColor = .systemBlue
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        sc.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        return sc
    }()
    
    var metals: [FinanceUIModel] = []
    var currencies: [FinanceUIModel] = []
    var onSegmentChanged: ((FinanceSegment) -> Void)?
    
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        backgroundColor = .clear
        layer.cornerRadius = 0
        layer.shadowOpacity = 0
        layer.borderWidth = 0
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        addSubview(segmentControl)
        addSubview(stackView)
        
        segmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(32)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview().inset(0)
        }
    }
    
    func configure(with models: [FinanceUIModel]) {
        currencies = models.filter { !$0.pair.starts(with: "X") }
        metals = models.filter { $0.pair.starts(with: "X") }
        
        let segment: FinanceSegment = (segmentControl.selectedSegmentIndex == 0) ? .currencies : .metals
        reloadData(for: segment)
    }
}

// MARK: Objective Methods
@objc private extension FinanceCardView {
    func segmentChanged(_ sender: UISegmentedControl) {
        let segment: FinanceSegment = (sender.selectedSegmentIndex == 0) ? .currencies : .metals
        onSegmentChanged?(segment)
    }
}

// MARK: - Private Methods
private extension FinanceCardView {
    func reloadData(for segment: FinanceSegment) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let data = (segment == .currencies) ? currencies : metals
        
        for model in data {
            let itemView = createFinanceItemView(with: model)
            stackView.addArrangedSubview(itemView)
        }
    }
    
    func createFinanceItemView(with model: FinanceUIModel) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemBackground
        }
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.separator.cgColor
        
        let pairContainer = UIView()
        pairContainer.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .tertiarySystemBackground : .secondarySystemBackground
        }
        pairContainer.layer.cornerRadius = 6
        
        let pairLabel = UILabel()
        pairLabel.text = model.pair
        pairLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        pairLabel.textColor = .label
        pairLabel.textAlignment = .center
        pairLabel.adjustsFontSizeToFitWidth = true
        pairLabel.minimumScaleFactor = 0.5
        
        pairContainer.addSubview(pairLabel)
        containerView.addSubview(pairContainer)
        
        let isMetal = model.pair.starts(with: "X")
        let boxWidth: CGFloat = isMetal ? 90 : 70
        let bidContainer = createValueContainer(title: L("buy_title"), value: model.bid, color: .systemGreen)
        let offerContainer = createValueContainer(title: L("sell_title"), value: model.offer, color: .systemRed)
        
        containerView.addSubview(bidContainer)
        containerView.addSubview(offerContainer)
        
        pairContainer.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(80)
        }
        pairLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        offerContainer.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(boxWidth)
        }
        bidContainer.snp.makeConstraints { make in
            make.trailing.equalTo(offerContainer.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(boxWidth)
        }
        return containerView
    }
    
    func createValueContainer(title: String, value: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor.systemGray5.withAlphaComponent(0.2) : UIColor.systemGray6.withAlphaComponent(0.5)
        }
        container.layer.cornerRadius = 8
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
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        valueLabel.lineBreakMode = .byTruncatingTail
        
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
