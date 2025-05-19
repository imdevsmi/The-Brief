//
//  SplashVC.swift
//  News
//
//  Created by Sami Gündoğan on 18.05.2025.
//

import SnapKit
import UIKit

protocol SplashVCProtocol: AnyObject {
    
}

final class SplashVC: UIViewController {
    
    // MARK: Properties
    
    private let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "newspaper.fill")
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let newsLabel: UILabel = {
        let label = UILabel()
        label.text = "Sami News"
        label.textColor = .label
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private var splashVM: SplashVM
    
    // MARK: Inits
    
    init(viewModel: SplashVM = .init()){
        self.splashVM = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Private Methods

private extension SplashVC {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupViews()
        setupLayout()
    }
    
    func setupViews() {
        view.addSubview(newsImage)
        view.addSubview(newsLabel)
    }
    
    func setupLayout() {
        newsImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-16)
            make.width.height.equalTo(224)
        }
        
        newsLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImage.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
    }
}

// MARK: Output Protocol

extension SplashVC: SplashVCProtocol {
    func ToMainScene() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
    }
}
