//
//  NewsDetailVC.swift
//  The Brief
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import SnapKit
import UIKit

protocol NewsDetailVMOutputProtocol: AnyObject { }

final class NewsDetailVC: UIViewController {
    
    //  MARK: Properties
    private let viewModel: NewsDetailVM
    private let favoritesService: FavoritesServicesProtocol
    
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
        var fullContent = ""

        if let content = viewModel.article.content, !content.isEmpty {
            fullContent += content + "\n\n"
        }

        if let description = viewModel.article.description, !description.isEmpty {
            fullContent += description
        }

        label.text = fullContent
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
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        
        button.addAction(UIAction { _ in
            self.saveTapped()
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: Inits
    init(viewModel: NewsDetailVM, favoritesService: FavoritesServicesProtocol = FavoriteService()) {
        self.viewModel = viewModel
        self.favoritesService = favoritesService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        DispatchQueue.main.async {
            self.checkIfArticleIsFavorited()
        }
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
        scrollView.addSubview(stackView)
        view.addSubview(saveButton)
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom).inset(80)
            make.width.equalTo(scrollView.snp.width)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.height.equalTo(50)
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(imageDescriptionLabel)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(240)
        }
    }
    
    func setupNavigationBar() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    func checkIfArticleIsFavorited() {
        favoritesService.fetchFavorites { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    let isFavorited = articles.contains { $0.url == self.viewModel.article.url }
                    self.updateSaveButtonAppearance(isFavorited: isFavorited)
                case .failure:
                    break
                }
            }
        }
    }
    
    func updateSaveButtonAppearance(isFavorited: Bool) {
        var config = saveButton.configuration
        if isFavorited {
            config?.title = "Saved"
            config?.image = UIImage(systemName: "bookmark.fill")
            config?.baseForegroundColor = .systemBlue
        } else {
            config?.title = "Save"
            config?.image = UIImage(systemName: "bookmark")
            config?.baseForegroundColor = .label
        }
        saveButton.configuration = config
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
        favoritesService.createFavoriteArticleDatabase()
        
        favoritesService.saveFavoriteArtice(viewModel.article) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.updateSaveButtonAppearance(isFavorited: true)
                    UserDefaults.standard.synchronize()
                case .failure:
                    self?.checkIfArticleIsFavorited()
                }
            }
        }
    }
}
