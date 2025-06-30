//
//  NewsDetailVC.swift
//  News
//
//  Created by Sami Gündoğan on 28.05.2025.
//

import SnapKit
import UIKit

protocol NewsDetailVMOutputProtocol: AnyObject {
    
}

final class NewsDetailVC: UIViewController {
    
    //  MARK: Properties
    var viewModel: NewsDetailVM
    
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
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        
        return label
    }()
    
    // MARK: Inits
    init(viewModel: NewsDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        view.backgroundColor = .systemBackground
        addViews()
        configureLayout()
        setupNavigationBar()
    }
    
    func addViews() {
        view.addSubview(scrollView)
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
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }

        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(240)
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
}
