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
    var glassTintColor: UIColor = UIColor.white.withAlphaComponent(0.02)
    
    private let blurView: UIVisualEffectView
    private let overlayView = UIView()
    private let shineLayer = CAGradientLayer()
    
    // MARK: - Init
    init(frame: CGRect,blurStyle: UIBlurEffect.Style = .systemThinMaterialLight,shineColors: [CGColor]? = nil, shineDuration: CFTimeInterval = 5) {
        self.shineColors = shineColors ?? [UIColor.white.withAlphaComponent(0.08).cgColor, UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.05).cgColor]
        self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        self.shineDuration = shineDuration
        self.blurStyle = blurStyle
        super.init(frame: frame)
        
        setupUI()
        setupShine()
        animateShine()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - Private Extensions
private extension LiquidGlassView {
    func setupUI() {
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        
        overlayView.frame = bounds
        overlayView.backgroundColor = glassTintColor
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(overlayView)
    }
    
    func setupShine() {
        shineLayer.colors = shineColors
        shineLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shineLayer.endPoint = CGPoint(x: 1, y: 0.5)
        shineLayer.frame = bounds
        shineLayer.opacity = 0.35
        layer.addSublayer(shineLayer)
    }
    
    // MARK: - Animations
    func animateShine() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = shineDuration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shineLayer.add(animation, forKey: "shineMove")
    }
}
