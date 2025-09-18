//
//  LiquidGlass.swift
//  The Brief
//
//  Created by Sami Gündoğan on 18.09.2025.
//

import UIKit

final class LiquidGlassView: UIView {
    
    // MARK: - Properties
    var blurStyle: UIBlurEffect.Style
    var shineColors: [CGColor]
    var shineDuration: CFTimeInterval
    
    private let blurView: UIVisualEffectView
    
    // MARK: - Init
    init(frame: CGRect, blurStyle: UIBlurEffect.Style = .systemThinMaterialLight, shineColors: [CGColor]? = nil, shineDuration: CFTimeInterval = 5) {
        self.shineColors = shineColors ?? [UIColor.white.withAlphaComponent(0.15).cgColor, UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.1).cgColor]
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        self.shineDuration = shineDuration
        self.blurStyle = blurStyle
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) { fatalError() }
}
