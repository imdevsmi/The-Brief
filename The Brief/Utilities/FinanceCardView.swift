//
//  FinanceCardView.swift
//  The Brief
//
//  Created by Sami Gündoğan on 2.10.2025.
//

import SnapKit
import UIKit

final class FinanceCardView: UIView {
    
    private let titleLabel =  UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetupUI()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func SetupUI() {
        
    }
}
