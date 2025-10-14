//
//  LiquidGlass.swift
//  The Brief
//
//  Created by Sami Gündoğan on 18.09.2025.
//

import UIKit

// MARK: - Enhanced Liquid Glass View
final class LiquidGlassView: UIView {
    
    // MARK: - Properties
    var blurStyle: UIBlurEffect.Style
    var shineColors: [CGColor]
    var shineDuration: CFTimeInterval
    var glassTintColor: UIColor = UIColor.white.withAlphaComponent(0.03)
    var borderColor: UIColor = UIColor.white.withAlphaComponent(0.2)
    
    private let blurView: UIVisualEffectView
    private let vibrancyView: UIVisualEffectView
    private let overlayView = UIView()
    private let shineLayer = CAGradientLayer()
    private let borderLayer = CAGradientLayer()
    private let noiseLayer = CALayer()
    
    // MARK: - Init
    init(frame: CGRect,
         blurStyle: UIBlurEffect.Style = .systemChromeMaterial,
         shineColors: [CGColor]? = nil,
         shineDuration: CFTimeInterval = 6) {
        
        self.shineColors = shineColors ?? [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(0.12).cgColor,
            UIColor.white.withAlphaComponent(0.0).cgColor
        ]
        
        self.blurStyle = blurStyle
        self.shineDuration = shineDuration
        
        let blur = UIBlurEffect(style: blurStyle)
        self.blurView = UIVisualEffectView(effect: blur)
        
        let vibrancy = UIVibrancyEffect(blurEffect: blur, style: .fill)
        self.vibrancyView = UIVisualEffectView(effect: vibrancy)
        
        super.init(frame: frame)
        
        setupUI()
        setupBorder()
        setupShine()
        setupNoise()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shineLayer.frame = bounds
        borderLayer.frame = bounds
        noiseLayer.frame = bounds
    }
}

// MARK: - Private Setup
private extension LiquidGlassView {
    func setupUI() {
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        
        vibrancyView.frame = bounds
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.contentView.addSubview(vibrancyView)
        overlayView.frame = bounds
        overlayView.backgroundColor = glassTintColor
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(overlayView)
        layer.cornerRadius = 0
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
    
    func setupBorder() {
        borderLayer.colors = [
            borderColor.cgColor,
            UIColor.white.withAlphaComponent(0.05).cgColor,
            borderColor.cgColor
        ]
        borderLayer.startPoint = CGPoint(x: 0, y: 0)
        borderLayer.endPoint = CGPoint(x: 1, y: 1)
        borderLayer.frame = bounds
    
        let borderWidth: CGFloat = 0.5
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(rect: bounds)
        let innerPath = UIBezierPath(rect: bounds.insetBy(dx: borderWidth, dy: borderWidth))
        path.append(innerPath)
        path.usesEvenOddFillRule = true
        
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        borderLayer.mask = maskLayer
        
        layer.addSublayer(borderLayer)
    }
    
    func setupShine() {
        shineLayer.colors = shineColors
        shineLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shineLayer.endPoint = CGPoint(x: 1, y: 0.5)
        shineLayer.frame = bounds
        shineLayer.opacity = 1.0
        shineLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(shineLayer)
    }
    
    func setupNoise() {
        if let noiseImage = generateNoiseImage() {
            noiseLayer.contents = noiseImage.cgImage
            noiseLayer.opacity = 0.02
            noiseLayer.frame = bounds
            layer.addSublayer(noiseLayer)
        }
    }
    
    func generateNoiseImage() -> UIImage? {
        let size = CGSize(width: 200, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            _ = CGRect(origin: .zero, size: size)
            
            for _ in 0..<2000 {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let alpha = CGFloat.random(in: 0.1...0.3)
                
                UIColor.white.withAlphaComponent(alpha).setFill()
                context.fill(CGRect(x: x, y: y, width: 1, height: 1))
            }
        }
    }
}
