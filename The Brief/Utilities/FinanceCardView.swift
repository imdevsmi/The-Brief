//
//  FinanceCardView.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import SnapKit
import UIKit

final class FinanceCardView: UIView {

    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [L("currencies_title"), L("metals_title")])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .clear
        sc.selectedSegmentTintColor = .systemBlue
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        
        return sc
    }()

    private let stackView = UIStackView()

    var metals: [FinanceUIModel] = []
    var currencies: [FinanceUIModel] = []
    var onSegmentChanged: ((FinanceSegment) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        segmentControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
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

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let segment: FinanceSegment = (sender.selectedSegmentIndex == 0) ? .currencies : .metals
        onSegmentChanged?(segment)
        reloadData(for: segment)
    }

    func configure(with models: [FinanceUIModel]) {
        currencies = models.filter { !$0.pair.starts(with: "X") }
        metals = models.filter { $0.pair.starts(with: "X") }

        let segment: FinanceSegment = (segmentControl.selectedSegmentIndex == 0) ? .currencies : .metals
        reloadData(for: segment)
    }

    private func reloadData(for segment: FinanceSegment) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let data = (segment == .currencies) ? currencies : metals

        for model in data {
            let itemView = createFinanceItemView(with: model)
            stackView.addArrangedSubview(itemView)
        }
    }

    private func createFinanceItemView(with model: FinanceUIModel) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear

        let pairLabel = UILabel()
        pairLabel.text = model.pair
        pairLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        pairLabel.textColor = .label
        
        let isMetal = model.pair.starts(with: "X")
        let boxWidth: CGFloat = isMetal ? 90 : 70
        
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
            make.width.equalTo(boxWidth)
        }
        bidContainer.snp.makeConstraints { make in
            make.trailing.equalTo(offerContainer.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(boxWidth)
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
            make.top.equalToSuperview().offset(2)
            make.leading.trailing.equalToSuperview().inset(4)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(2)
        }
        return container
    }
}

