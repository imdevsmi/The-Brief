//
//  NewsDetailVC.swift
//  News
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import SnapKit
import UIKit

protocol NewsDetailVMOutputProtocol: AnyObject { }

final class NewsDetailVC: UIViewController {
    
    //  MARK: Properties
    private let viewModel: NewsDetailVM
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.article.title
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.textColor = .label
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "By: \(viewModel.article.author ?? "Unknown")"
        label.textAlignment = .natural
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.setImage(with: viewModel.article.urlToImage, placeholder: UIImage(systemName: "photo.artframe"))
        imageView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()
    
    private lazy var imageDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.article.content ?? "")\n\n\(viewModel.article.description ?? "")\n\n\(viewModel.article.content ?? "")\n\n\(viewModel.article.description ?? "")\n\n\(viewModel.article.content ?? "")\n\n\(viewModel.article.description ?? "")"
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Save"
        config.image = UIImage(systemName: "bookmark.fill")
        config.imagePadding = 4
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 16, weight: .semibold)
            return outgoing
        }
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        
        button.addAction(UIAction { _ in
            self.saveTapped()
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Inits
    init(viewModel: NewsDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

// MARK: - Private Methods
private extension NewsDetailVC {
    func setupUI() {
        addViews()
        configureLayout()
        setupNavigationBar()
    }
    
    func addViews() {
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(imageDescriptionLabel)
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView)
            make.bottom.equalTo(scrollView).inset(80)
            make.width.equalTo(scrollView.snp.width)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(240)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.height.equalTo(50)
        }
    }
    
    func setupNavigationBar() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem = shareButton
    }
}

// MARK: Objective Methods
@objc private extension NewsDetailVC {
    func imageTapped() {
        let previewVC = ImagePreview(imageURL: viewModel.article.urlToImage)
        previewVC.modalPresentationStyle = .fullScreen
        present(previewVC, animated: true)
    }
    
    func shareTapped() {
        guard let urlString = viewModel.article.url, let shareUrl = URL(string: urlString) else { return }
        
        let openBrowser = openBrowser()
        let activityVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: [openBrowser])
        
        present(activityVC, animated: true)
    }
    
    func saveTapped() {
        
    }
}
