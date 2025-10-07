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
        layer.masksToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with models: [FinanceUIModel]){
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for model in models {
            let label = UILabel()
            label.text = "\(model.pair): \(model.bid) / \(model.offer)"
            label.font = .systemFont(ofSize: 16)
            label.textColor = .label
            stackView.addArrangedSubview(label)
        }
    }
}
