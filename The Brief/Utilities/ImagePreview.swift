//
//  ImagePreview.swift
//  The Brief
//
//  Created by Sami Gündoğan on 17.06.2025.
//

import SnapKit
import UIKit

final class ImagePreview: UIViewController {
    // MARK: Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        button.tintColor = .white
        button.setImage(config, for: .normal)
        
        return button
    }()
    
    private let imageURL: String?
    private var originalPosition: CGPoint?
    private var dismissThreshold: CGFloat = 100
    
    // MARK: Inits
    
    init(imageURL: String?) {
        self.imageURL = imageURL
        if let imageURL = imageURL {
            imageView.setImage(with: imageURL, placeholder: UIImage(systemName: "photo"))
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupUI()
    }
}

// MARK: - Private Methods

private extension ImagePreview {
    func configureView() {
        view.backgroundColor = .black
        scrollView.delegate = self
        
        configureLayout()
        addViews()
    }
    
    func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(closeButton)
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height)
            make.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.width.height.equalTo(40)
        }
    }
    
    func setupUI() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }
}

// MARK: - Objective Methods

@objc private extension ImagePreview {
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let scale = scrollView.zoomScale == 1.0 ? 2.0 : 1.0
        let tapPoint = gesture.location(in: imageView)
        
        let zoomRect = CGRect(
            x: tapPoint.x - (scrollView.frame.size.width / scale) / 2,
            y: tapPoint.y - (scrollView.frame.size.height / scale) / 2,
            width: scrollView.frame.size.width / scale,
            height: scrollView.frame.size.height / scale)
        
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard scrollView.zoomScale == 1.0 else { return }
        
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .began:
            originalPosition = view.center
            
        case .changed:
            if translation.y > 0 {
                view.center = CGPoint(x: originalPosition!.x, y: originalPosition!.y + translation.y)
            }
            
        case .ended:
            if translation.y > dismissThreshold {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.center = self.originalPosition!
                }
            }
            
        default:
            break
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ImagePreview: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }

    private func centerImage() {
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        imageView.frame = frameToCenter
    }
}
