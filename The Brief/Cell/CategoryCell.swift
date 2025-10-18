//
//  CategoryCell.swift
//  The Brief
//
//  Created by Sami Gündoğan on 11.09.2025.
//

import SnapKit
import UIKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with title: String, selected: Bool, backgroundColor: UIColor = .secondarySystemBackground, textColor: UIColor = .label ) {
        titleLabel.text = title
        titleLabel.textColor = textColor
        contentView.backgroundColor = backgroundColor
        layer.cornerRadius = 20
    }
}
